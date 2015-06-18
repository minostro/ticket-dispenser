%%% @author   Milton Inostroza <milinostroza@groupon.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc      

-module(dispenser_front_desk).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-author('Milton Inostroza <milinostroza@groupon.com>').
-record(state, {worker_supervisor_pid}).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start_link/1, add_dispenser/1]).


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
   ok.

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
init([SupervisorPid]) ->
  self() ! {start_worker_supervisor, SupervisorPid},
  {ok, #state{}}.

handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info({start_worker_supervisor, SupervisorPid}, State) ->
  ChildSpec = {
    dispenser_worker_sup,
    {dispenser_worker_sup, start_link, []},
    transient,
    brutal_kill,
    worker,
    [dispenser_worker_sup]
  },
  {ok, Pid} = supervisor:start_child(SupervisorPid, ChildSpec),
  {noreply, #state{worker_supervisor_pid=Pid}};
handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
