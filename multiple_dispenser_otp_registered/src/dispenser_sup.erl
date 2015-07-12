%%%-------------------------------------------------------------------
%% @doc dispenser top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(dispenser_sup).

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
  DispenserFrontDeskSpec = {
    dispenser_front_desk,
    {dispenser_front_desk, start_link, []},
    transient,
    brutal_kill,
    worker,
    [dispenser_front_desk, dispenser_worker_sup]
  },
  DispenserWorkerSupSpec = {
    dispenser_worker_sup,
    {dispenser_worker_sup, start_link, []},
    permanent,
    brutal_kill,
    supervisor,
    [dispenser_worker_sup]
  },
  {ok, {{one_for_all, 10, 20}, [DispenserFrontDeskSpec, DispenserWorkerSupSpec]}}.

%%====================================================================
%% Internal functions
%%====================================================================
