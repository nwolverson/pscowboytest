module WebSocketHandler (init) where

import Prelude

import Effect.Console (log)
import Effect.Uncurried (mkEffectFn2)
import Erl.Cowboy.Handlers.WebSocket (Frame(..), FrameHandler, InfoHandler, InitHandler, CowboyWebsocketBehaviour, cowboyWebsocketBehaviour, decodeInFrame, initResult, okResult, outFrame, replyResult)
import Erl.Data.List (singleton)

type HandlerState = Unit

_behaviour :: CowboyWebsocketBehaviour
_behaviour = cowboyWebsocketBehaviour { init, websocket_handle, websocket_info }

init :: forall a. InitHandler a HandlerState
init = mkEffectFn2 \req _ -> pure (initResult unit req)

websocket_handle :: FrameHandler HandlerState
websocket_handle = mkEffectFn2 \frame s -> do
  log "Got frame!"
  let frames = case decodeInFrame frame of
                  f@(TextFrame _) -> singleton $ outFrame f
                  _ -> mempty
  case decodeInFrame frame of
    TextFrame tf -> log $ "Text frame: " <> tf
    BinaryFrame _ -> log "Binary frame"
    PingFrame _ -> log "Ping"
    PongFrame _ -> log "Pong"
  pure $ replyResult s frames

websocket_info :: InfoHandler HandlerState
websocket_info = mkEffectFn2 \_ s -> pure $ okResult s
