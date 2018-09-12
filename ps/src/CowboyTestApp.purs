module CowboyTestApp where

import Prelude hiding (mod)

import Attribute (Attribute(..), Behaviour)
import Effect (Effect)
import Effect.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Erl.Atom (Atom, atom)
import Erl.Cowboy (ProtoEnv(..), ProtoOpt(..), TransOpt(..), startClear, protocolOpts, env)
import Erl.Cowboy.Routes (compile, mod)
import Erl.Data.List (nil, singleton, (:))
import Erl.Data.Tuple (Tuple2, tuple2, tuple3, tuple4)

_behaviour :: Behaviour "application"
_behaviour = Attribute

foreign import data Pid :: Type

foreign import startLink :: Effect (Tuple2 Atom Pid)

start :: forall a b. a -> b -> (Tuple2 Atom Pid)
start _ _ = unsafePerformEffect do
  let paths = tuple3 "/simple/[...]" (mod "loopHandler@ps") nil
                : tuple3 "/simpleM/[...]" (mod "loopHandler@ps") nil
                : tuple3 "/loop/[...]" (mod "loopHandler@ps") nil
                : tuple3 "/rest/[...]" (mod "restHandler@ps") nil
                : tuple3 "/ws/[...]" (mod "webSocketHandler@ps") nil
                : tuple3 "/json/[...]" (mod "jsonHandler@ps") nil
                : nil
      routes = singleton (tuple2 (atom "_") paths)
      dispatch = compile routes
      transOpts = Ip (tuple4 0 0 0 0) : Port 8082 : nil
      protoOpts = protocolOpts $ Env (env (Dispatch dispatch 
        : Fn (log "env fn!") 
        : nil))
        -- : Middlewares (
        --     mod "cowboy_router"
        --     : mod "fnMiddleware@ps"
        --     : mod "cowboy_handler"
        --     : nil
        --   )
        : nil
  res <- startLink
  _ <- startClear (atom "http_listener") transOpts protoOpts
  log "Started HTTP listener on port 8082. Try routes: /simple ; /simpleM ; /loop ; /rest ; /ws (websocket endpoint) ; /json"
  pure res

stop :: forall a. a -> Atom
stop _ = atom "ok"
