-module(dispenser).
-export([start/0, start_link/0, stop/0]).

%% @spec start_link() -> {ok,Pid::pid()}
%% @doc Starts the app for inclusion in a supervisor tree
start_link() ->
    LogHandlers = [{webmachine_access_log_handler, ["priv/log"]},
                   {webmachine_error_log_handler, ["priv/log"]}],
    application:set_env(webmachine, log_handlers, LogHandlers),
    webmachine_util:ensure_all_started(webmachine),
    dispenser_sup:start_link().

%% @spec start() -> ok
%% @doc Start the dispenser server.
start() ->
    LogHandlers = [{webmachine_access_log_handler, ["priv/log"]},
                   {webmachine_error_log_handler, ["priv/log"]}],
    application:set_env(webmachine, log_handlers, LogHandlers),
    webmachine_util:ensure_all_started(webmachine),
    application:start(dispenser).

%% @spec stop() -> ok
%% @doc Stop the dispenser server.
stop() ->
    Res = application:stop(dispenser),
    application:stop(webmachine),
    application:stop(mochiweb),
    application:stop(crypto),
    Res.