%%% @author   Milton Inostroza <minostro@minostro.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc

-module(dispenser_api).
-author('Milton Inostroza <minostro@minostro.com>').

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start/0, current_ticket/1, take_ticket/1, reset/1, stop/1]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start() ->
  dispenser:start().

current_ticket(Pid) ->
  dispenser:current_ticket(Pid).

take_ticket(Pid) ->
  dispenser:take_ticket(Pid).

reset(Pid) ->
  dispenser:reset(Pid).

stop(Pid) ->
  dispenser:stop(Pid).