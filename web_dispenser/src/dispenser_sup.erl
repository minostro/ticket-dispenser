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
  FrontDesk = {dispenser_front_desk,
                {dispenser_front_desk, start_link, [self()]},
                  transient, brutal_kill, worker, [dispenser_front_desk]
  },
  Web = {webmachine_mochiweb,
           {webmachine_mochiweb, start, [dispenser_config:web_config()]},
           permanent, 5000, worker, [mochiweb_socket_server]},  
  {ok, {{one_for_one, 10, 20}, [FrontDesk, Web]}}.

%%====================================================================
%% Internal functions
%%====================================================================