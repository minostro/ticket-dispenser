-module(dispenser_resource).
-export([init/1]).

-export([allowed_methods/2,
         to_html/2,
         content_types_accepted/2,
         resource_exists/2,
         from_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) ->
  {ok, undefined}.

allowed_methods(ReqData, Context) ->
  {['GET', 'PUT'], ReqData, Context}.

content_types_accepted(ReqData, Context) ->
  {[{"application/json", from_json}], ReqData, Context}.

resource_exists(ReqData, Context) ->
  {true, ReqData, Context}.

from_json(ReqData, Context) ->
  DispenserName = list_to_atom(wrq:disp_path(ReqData)),
  {ok, _} = add_dispenser(DispenserName),
  %HINT: not enterily sure what do I need to do here..I guess
  %I need to provide a path??
  {true, wrq:set_resp_body(wrq:req_body(ReqData), ReqData), Context}.

to_html(ReqData, Context) ->
  {ok, Dispensers} = dispenser_api:get_dispensers(),
  Body = io_lib:format("<html><body> ~w </body></html>", [Dispensers]),
  {Body, ReqData, Context}.

add_dispenser(DispenserName) when is_atom(DispenserName) ->
  dispenser_api:add_dispenser(DispenserName);
add_dispenser(DispenserName) ->
  dispenser_api:add_dispenser(list_to_atom(DispenserName)).
