%%%-------------------------------------------------------------------
%% @doc dispenser top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module('dispenser_sup').

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
  supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
init([]) ->
  ChildSpec = {
    dispenser_worker,
    {dispenser_worker, start_link, []},
    transient,
    brutal_kill,
    worker,
    [dispenser_worker]
  },
  {ok, {{one_for_all, 10, 20}, [ChildSpec]}}.

%%====================================================================
%% Internal functions
%%====================================================================
