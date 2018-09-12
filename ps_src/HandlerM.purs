module HandlerM  where

import Prelude

import Control.Monad.State (runStateT)
import Data.Tuple (uncurry)
import Effect.Uncurried (mkEffectFn2)
import Erl.Cowboy.Handler (HandlerM, runHandlerM)
import Erl.Cowboy.Handlers.Simple (CowboyHandlerBehaviour, InitHandler, cowboyHandlerBehaviour, initResult)
import Erl.Cowboy.Req (StatusCode(..))
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Data.Map as M

_behaviour :: CowboyHandlerBehaviour
_behaviour = cowboyHandlerBehaviour { init }

data Config
data HandlerState = HandlerState

init :: InitHandler Config HandlerState
init = mkEffectFn2 \req config -> 
  uncurry initResult <$> runStateT (helloHandler config) req

initAlt :: InitHandler Config HandlerState
initAlt = mkEffectFn2 \req config -> runHandlerM initResult (helloHandler config) req
  
helloHandler :: Config -> HandlerM HandlerState
helloHandler config = do
  let headers = M.singleton "content-type" "text/plain"
  path <- ReqM.path
  qs <- ReqM.qs
  let response = "Hello! Path is " <> path <> " and query string is " <> qs
  ReqM.reply (StatusCode 200) headers response
  pure HandlerState
  