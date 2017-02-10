-module(cowboyRoutes@foreign).
-export([atom/1, compile/1, startLink/0, startHttp/3, startHttpSimple/1, string/1]).

% TODO: Fails on higher unicode chars! Currently.
atom(S) -> binary_to_atom(S, utf8).

compile(Routes) -> cowboy_router:compile(Routes).
startLink() -> fun () -> pscowboytest_sup:start_link() end.
startHttp(NumAcceptors, TransOpts, ProtoOpts) -> fun () ->
  cowboy:start_http(the_http_listener, NumAcceptors, TransOpts, ProtoOpts) end.
startHttpSimple(Routes) -> fun () ->
  io:put_chars("startHttpSimple"),
  Routes1 = [ {
    '_',
    [
      {"/json/[...]", jsonHandler@ps, []},
      {"/[...]", handler@ps, []}
    ]
    } ],
  cowboy:start_http(the_http_listener, 10, [ {ip, {0,0,0,0}}, {port, 8081} ],
    [{env, [{dispatch, cowboy_router:compile(Routes)}]}]) end.
string(S) -> unicode:characters_to_list(S, utf8).
