module CowboyRoutes where

import Prelude
import Erl.Data.List
import Control.Monad.Eff (Eff)
import Erl.Cowboy.Req (Ok)
import Erl.Data.Tuple (Tuple2, Tuple3, Tuple4)

type Routes a = List (Tuple2 Atom (Paths a))
type Paths a = List (Tuple3 CharString Module a)
type Module = Atom

foreign import data Atom :: *

foreign import atom :: String -> Atom

foreign import data Dispatch :: *
foreign import compile :: forall a. Routes a -> Dispatch

foreign import data PROCESS :: !
foreign import data Pid :: *
foreign import startLink :: forall eff. Eff (process :: PROCESS | eff) (Tuple2 Ok Pid)
-- the_http_listener,
--     NumAcceptors, TransOpts, ProtoOpts),
--
--     TransOpts = [ {ip, {0,0,0,0}}, {port, 8081} ],
--     ProtoOpts = [{env, [{dispatch, Dispatch}]}],
foreign import startHttp :: forall eff. Int -> List TransOpt -> List ProtoOpt -> Eff (process :: PROCESS | eff) Unit

foreign import startHttpSimple :: forall eff a. Routes a -> Eff (process :: PROCESS | eff) Unit

data TransOpt = Ip (Tuple4 Int Int Int Int) | Port Int
data ProtoOpt = Env (List ProtoEnv)
data ProtoEnv = Dispatch Dispatch

foreign import data CharString :: *
foreign import string :: String -> CharString


-- {ok, Pid} = pscowboytest_sup:start_link(),
-- Routes = [ {
--   '_',
--   [
--     {"/json/[...]", jsonHandler@ps, []},
--     {"/[...]", handler@ps, []}
--   ]
--   } ],
-- Dispatch = cowboy_router:compile(Routes),
