-module(root_handler).
-export([init/2, terminate/3]).

init(Req, _Opts) -> ((cowboyTest@ps:handlerM())(Req))(no_state).

terminate(_Reason, _Req, _State) -> ok.
