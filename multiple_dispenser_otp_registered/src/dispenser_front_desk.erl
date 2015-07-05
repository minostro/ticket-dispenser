%%% @author   Milton Inostroza <minostro@minostro.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc      

-module(dispenser_front_desk).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-author('Milton Inostroza <minostro@minostro.com>').
-record(state, {mapping}).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start_link/0, add_dispenser/1, current_ticket/1]).


%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------
-export([init/1, handle_call/3, handle_cast/2, terminate/2, handle_info/2, code_change/3]).


%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start_link() ->
  gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

add_dispenser(Name) ->
  gen_server:call(?SERVER, {add_dispenser, Name}).


current_ticket(Name) ->
  gen_server:call(?SERVER, {current_ticket, Name}).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------
init(_Args) ->
  {ok, #state{mapping = #{}}}.
handle_call({add_dispenser, Name}, _From, #state{mapping = Mapping} = State) ->
  {ok, Child} = dispenser_worker_sup:add_worker(Name),
  {reply, ok, State#state{mapping = maps:put(Name, Child, Mapping)}};
handle_call({current_ticket, Name}, _From, #state{mapping = Mapping} = State) ->
  Worker = maps:get(Name, Mapping),
  Ticket = dispenser_worker:current_ticket(Worker),
  {reply, {ok, Ticket}, State};
handle_call(_Request, _From, State) ->
  {reply, ok, State}.

handle_cast(_Msg, State) ->
  {noreply, State}.

handle_info(_Info, State) ->
  {noreply, State}.

terminate(_Reason, _State) ->
  ok.

code_change(_OldVsn, State, _Extra) ->
  {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------
