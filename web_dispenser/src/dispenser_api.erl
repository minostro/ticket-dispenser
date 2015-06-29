%%% @author   Milton Inostroza <minostro@minostro.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc

-module(dispenser_api).
-author('Milton Inostroza <minostro@minostro.com>').

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start/0, add_dispenser/1, get_dispenser/1, dispenser_exists/1, current_ticket/1, take_ticket/0, reset/0, stop/0]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start() ->
  application:start(dispenser).

add_dispenser(Name) ->
  dispenser_front_desk:add_dispenser(Name).

current_ticket(Name) ->
  dispenser_front_desk:current_ticket(Name).

get_dispenser(Name) ->
  dispenser_front_desk:get_dispenser(Name).

dispenser_exists(Name) ->
  dispenser_front_desk:dispenser_exists(Name).

take_ticket() ->
  dispenser_worker:take_ticket().

reset() ->
  dispenser_worker:reset().

stop() ->
  application:stop(dispenser).
