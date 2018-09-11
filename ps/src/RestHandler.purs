module RestHandler where

import Prelude

import Effect.Console (log)
import Effect.Uncurried (EffectFn2, mkEffectFn2)
import Erl.Atom (atom)
import Erl.Cowboy.Handlers.Rest (ContentType(..), ContentTypeParams(..), ContentTypesProvidedHandler, InitHandler, ProvideCallback(..), contentTypesProvidedResult, initResult, restResult)
import Erl.Cowboy.Req (Req)
import Erl.Data.List (fromFoldable)
import Erl.Data.Tuple (Tuple3, tuple2, tuple3)

init :: forall a. InitHandler a a
init = mkEffectFn2 \req c -> pure (initResult c req)

content_types_provided :: forall s. ContentTypesProvidedHandler s
content_types_provided =  mkEffectFn2 \req s -> pure $
  restResult
    (contentTypesProvidedResult $ fromFoldable
      [ tuple2 (ContentType "text" "html" AnyParams) (ProvideCallback $ atom "asHtml")
      , tuple2 (ContentType "text" "plain" AnyParams) (ProvideCallback $ atom "asText")
      ]
    )
    s req

asHtml :: forall s. EffectFn2 Req s (Tuple3 String Req s)
asHtml = mkEffectFn2 \req s -> do
  log "Sending HTML!"
  pure $ tuple3 "<html><title>Hi</title></html>\n" req s

asText :: forall s. EffectFn2 Req s (Tuple3 String Req s)
asText = mkEffectFn2 \req s -> pure $ tuple3 "Hi\n" req s
