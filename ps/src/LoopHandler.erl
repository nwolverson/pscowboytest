-module(loopHandler@foreign).
-export([sendMessage/1]).

sendMessage(Msg) -> fun () ->
    self()!Msg
end.