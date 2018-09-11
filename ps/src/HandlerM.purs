module HandlerM  where

-- import Prelude

-- import Control.Monad.State (class MonadState, StateT(..), State, execStateT, runStateT)
-- import Data.Tuple (Tuple(..))
-- import Effect (Effect)
-- import Effect.Class (class MonadEffect)
-- import Effect.Unsafe (unsafePerformEffect)
-- import Erl.Cowboy.Handler (Handler, Ok(..), HandlerM, runHandlerM)
-- import Erl.Cowboy.Req (Req, StatusCode(..))
-- import Erl.Cowboy.Req.Monad as ReqM
-- import Erl.Data.Map as M


import Prelude

import Control.Monad.State (runState, runStateT)
import Data.Tuple (Tuple(..), uncurry)
import Effect.Uncurried (mkEffectFn2)
import Erl.Cowboy.Handler (HandlerM, runHandlerM)
import Erl.Cowboy.Handlers.Simple (InitHandler, initResult)
import Erl.Cowboy.Req (StatusCode(..))
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Data.Map as M

-- import Prelude

-- import Control.Monad.State (class MonadState, StateT(..), State, execStateT, runStateT)
-- import Data.Tuple (Tuple(..))
-- import Effect (Effect)
-- import Effect.Class (class MonadEffect)
-- import Effect.Unsafe (unsafePerformEffect)
-- import Erl.Cowboy.Handler (Handler, Ok(..), HandlerM, runHandlerM)
-- import Erl.Cowboy.Req (Req, StatusCode(..))
-- import Erl.Cowboy.Req.Monad as ReqM
-- import Erl.Data.Map as M


data Config
data HandlerState = HandlerState

init :: InitHandler Config HandlerState
init = mkEffectFn2 \req config -> 
  uncurry initResult <$> runStateT (helloHandler config) req
  
helloHandler :: Config -> HandlerM HandlerState
helloHandler config = do
  let headers = M.singleton "content-type" "text/plain"
  path <- ReqM.path
  qs <- ReqM.qs
  let response = "Hello! Path is " <> path <> " and query string is " <> qs
  ReqM.reply (StatusCode 200) headers response
  pure HandlerState
  