module CowboyTestApp where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log, CONSOLE)
import Control.Monad.Eff.Unsafe (unsafePerformEff)
import CowboyRoutes
import Erl.Cowboy.Req (Ok, ok)
import Erl.Data.List (nil, singleton, (:))
import Erl.Data.Tuple (Tuple2, tuple2, tuple3, tuple4)

start :: forall a b. a -> b -> (Tuple2 Ok Pid)
start _ _ = unsafePerformEff do
  res <- startLink
  startRouting
  pure res

startRouting :: forall eff. Eff (console :: CONSOLE, process :: PROCESS | eff) Unit
startRouting = do
  let paths = tuple3 (string "/[...]") (atom "handler@ps") nil
              : tuple3 (string "/json/[...]") (atom "jsonHandler@ps") nil
              : nil
      routes = singleton (tuple2 (atom "_") paths)
      dispatch = compile routes
      transOpts = Ip (tuple4 0 0 0 0) : Port 8082 : nil
      protoOpts = singleton $ Env (singleton $ Dispatch dispatch)
  _ <- startHttp 10 transOpts protoOpts
  log "Started HTTP listener on port 8082. Try routes / and /json"
  pure unit

stop :: forall a. a -> Ok
stop _ = ok
