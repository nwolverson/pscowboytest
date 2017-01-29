%%%-------------------------------------------------------------------
%% @doc pscowboytest public API
%% @end
%%%-------------------------------------------------------------------

-module(pscowboytest_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_StartType, _StartArgs) ->
    {ok, Pid} = pscowboytest_sup:start_link(),
    Routes = [ {
      '_',
      [
        {"/json/[...]", json_handler, []},
        {"/[...]", root_handler, []}
      ]
      } ],
    Dispatch = cowboy_router:compile(Routes),

    NumAcceptors = 10,
    TransOpts = [ {ip, {0,0,0,0}}, {port, 8081} ],
    ProtoOpts = [{env, [{dispatch, Dispatch}]}],

    {ok, _} = cowboy:start_http(the_http_listener,
        NumAcceptors, TransOpts, ProtoOpts),

    {ok, Pid}.

%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================
