-module(dispenser_resource).
-export([init/1]).

-export([allowed_methods/2,
         to_html/2,
         to_json/2,
         content_types_provided/2,
         content_types_accepted/2,
         resource_exists/2,
         from_json/2]).

-include_lib("webmachine/include/webmachine.hrl").

init([]) ->
  {ok, undefined}.

allowed_methods(ReqData, Context) ->
  {['GET', 'PUT'], ReqData, Context}.

content_types_provided(ReqData, Context) ->
  {[{"text/html", to_html}, {"application/json", to_json}], ReqData, Context}.

content_types_accepted(ReqData, Context) ->
  {[{"application/json", from_json}], ReqData, Context}.

to_html(ReqData, Context) ->
  Id = path_info_for(id, ReqData),
  Response = io_lib:format("<html><body>Id: ~s</body></html>", [Id]),
  {Response, ReqData, Context}.

to_json(ReqData, Context) ->
  Id = path_info_for(id, ReqData),
  {ok, Dispenser} = dispenser_api:get_dispenser(Id),
  Response = dispenser_to_json(Dispenser),
  {Response, ReqData, Context}.

resource_exists(ReqData, Context) ->
  Id = path_info_for(id, ReqData),
  {ok, Exists} = dispenser_api:dispenser_exists(Id),
  {Exists, ReqData, Context}.

from_json(ReqData, Context) ->
  {ok, Dispenser} = dispenser_api:add_dispenser(path_info_for(id, ReqData)),
  Response = wrq:set_resp_body(dispenser_to_json(Dispenser), ReqData),
  {true, Response, Context}.

path_info_for(Identifier, ReqData) ->
  list_to_atom(wrq:path_info(Identifier, ReqData)).

dispenser_to_json([Name, Pid]) ->
  mochijson:encode(
    {struct, [{name, atom_to_list(Name)},
              {pid, pid_to_list(Pid)}]}).

