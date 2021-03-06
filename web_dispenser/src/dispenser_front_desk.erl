%%% @author   Milton Inostroza <minostro@minostro.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc      

-module(dispenser_front_desk).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-author('Milton Inostroza <minostro@minostro.com>').
-record(state, {worker_supervisor_pid, mapping}).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start_link/1, add_dispenser/1, current_ticket/1, get_dispenser/1, dispenser_exists/1]).


%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, terminate/2, handle_info/2, code_change/3]).


%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start_link(SupervisorPid) ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [SupervisorPid], []).

add_dispenser(Name) ->
  gen_server:call(?SERVER, {add_dispenser, Name}).

current_ticket(Name) ->
  gen_server:call(?SERVER, {current_ticket, Name}).

get_dispenser(Name) ->
  gen_server:call(?SERVER, {get_dispenser, Name}).

dispenser_exists(Name) ->
  gen_server:call(?SERVER, {dispenser_exists, Name}).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
init([SupervisorPid]) ->
  self() ! {start_worker_supervisor, SupervisorPid},
  {ok, #state{mapping = #{}}}.
handle_call({add_dispenser, Name}, _From, #state{worker_supervisor_pid = Pid, mapping = Mapping} = State) ->
  {ok, Child} = supervisor:start_child(Pid, []),
  {reply, {ok, [Name, Child]}, State#state{mapping = maps:put(Name, Child, Mapping)}};
handle_call({get_dispenser, Name}, _From, #state{mapping=Mapping} = State) ->
  Dispenser = [Name, maps:get(Name, Mapping, error)],
  {reply, {ok, Dispenser}, State};
handle_call({current_ticket, Name}, _From, #state{mapping = Mapping} = State) ->
  Worker = maps:get(Name, Mapping),
  Ticket = dispenser_worker:current_ticket(Worker),
  {reply, {ok, Ticket}, State};
handle_call({dispenser_exists, Name}, _From, #state{mapping=Mapping} = State) ->
  {reply, {ok, maps:is_key(Name, Mapping)}, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({start_worker_supervisor, SupervisorPid}, State) ->
  ChildSpec = {
    dispenser_worker_sup,
    {dispenser_worker_sup, start_link, []},
    temporary,
    brutal_kill,
    supervisor,
    [dispenser_worker_sup]
  },
  {ok, Pid} = supervisor:start_child(SupervisorPid, ChildSpec),
  {noreply, State#state{worker_supervisor_pid=Pid}};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
