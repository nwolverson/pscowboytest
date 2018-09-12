module Handler (init) where

import Prelude

import Effect (Effect)
import Effect.Console (log)
import Effect.Uncurried (mkEffectFn2, mkEffectFn3)
import Erl.Cowboy.Handlers.Simple (CowboyHandlerBehaviour, InitHandler, InitResult, TerminateHandler, cowboyHandlerBehaviour, initResult, terminateResult)
import Erl.Cowboy.Req (Req, StatusCode(..), path, qs, reply)
import Erl.Data.Map as M

_behaviour :: CowboyHandlerBehaviour
_behaviour = cowboyHandlerBehaviour { init }

init :: forall a. InitHandler a Unit
init = mkEffectFn2 \req _ -> handle req unit

terminate :: forall s. TerminateHandler s
terminate = mkEffectFn3 \_ _ _ -> do
  log "Terminating"
  pure terminateResult

handle :: forall s. Req -> s -> Effect (InitResult s)
handle req state = do
  let headers = M.singleton "content-type" "text/plain"
      response = "Hello! path is " <> path req <> " and query string is " <> qs req
  req' <- reply (StatusCode 200) headers response req 
  log "Hello"
  log $ "Handling path: " <> path req
  pure $ initResult state req'
