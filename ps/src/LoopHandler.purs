module LoopHandler where

import Prelude

import Control.Monad.State (evalStateT, get)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Uncurried (mkEffectFn2, mkEffectFn3)
import Erl.Cowboy.Handler (HandlerM)
import Erl.Cowboy.Handlers.Loop (InfoHandler, InfoResult, InitHandler, continue, initResult, stop)
import Erl.Cowboy.Req (StatusCode(..), streamReply)
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Data.Binary.UTF8 as UTF8
import Erl.Data.Map as Map
  
data Message = Hello | Goodbye

foreign import sendMessage :: Message -> Effect Unit

type LoopHandlerState = Int

init :: forall a. InitHandler a LoopHandlerState
init = mkEffectFn2 \req _ -> do
  sendMessage Hello
  initResult 5 <$> streamReply (StatusCode 200) Map.empty req

info :: InfoHandler Message LoopHandlerState
info = mkEffectFn3 \msg req handlerState -> evalStateT (handler msg handlerState) req
  where
    handler Hello = onHello
    handler Goodbye = onGoodbye

onHello :: LoopHandlerState -> HandlerM (InfoResult LoopHandlerState)
onHello handlerState = do
  liftEffect $ sendMessage $
    if handlerState < 1 then Goodbye else Hello
  ReqM.streamBody (UTF8.toBinary $ "hello " <> show handlerState <> "\n")
  continue (handlerState - 1) <$> get

onGoodbye :: forall a. a -> HandlerM (InfoResult a)
onGoodbye handlerState = do
  ReqM.streamBodyFinal (UTF8.toBinary "goodbye\n")
  stop handlerState <$> get