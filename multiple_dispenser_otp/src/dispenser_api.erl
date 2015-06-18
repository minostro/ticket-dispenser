%%% @author   Milton Inostroza <minostro@minostro.com>
%%% @copyright  2015  Milton Inostroza.
%%% @doc

-module(dispenser_api).
-author('Milton Inostroza <minostro@minostro.com>').

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------
-export([start/0, current_ticket/0, take_ticket/0, reset/0, stop/0]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------
start() ->
  application:start(dispenser).

add_dispenser(Name) ->
	dispenser_front_desk:add_dispenser(Name).

current_ticket() ->
  dispenser_worker:current_ticket().

take_ticket() ->
  dispenser_worker:take_ticket().

reset() ->
  dispenser_worker:reset().

stop() ->
  dispenser_worker:stop().