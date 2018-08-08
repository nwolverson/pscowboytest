-module(cowboyTestApp@foreign).
-export([startLink/0]).

startLink() -> fun () -> pscowboytest_sup:start_link() end.
