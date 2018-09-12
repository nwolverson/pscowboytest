module JsonHandler where

import Prelude

import Effect (Effect)
import Effect.Uncurried (mkEffectFn2)
import Erl.Cowboy.Handlers.Simple (CowboyHandlerBehaviour, InitHandler, InitResult, cowboyHandlerBehaviour, initResult)
import Erl.Cowboy.Req (Req, StatusCode(..), path, qs, reply)
import Erl.Data.Jsone (jsonEmptyObject)
import Erl.Data.Jsone.Encode.Combinators ((~>), (:=))
import Erl.Data.Jsone.Printer (printJson)
import Erl.Data.Map as M

_behaviour :: CowboyHandlerBehaviour
_behaviour = cowboyHandlerBehaviour { init }

init :: forall a. InitHandler a Unit
init = mkEffectFn2 \req _ -> handle req unit

handle :: forall s. Req -> s -> Effect (InitResult s)
handle req state = do
  let headers = M.singleton "content-type" "application/json"
      resp    = ( "path" := path req
                ~> "query" := qs req
                ~> jsonEmptyObject )

  req' <- reply (StatusCode 200) headers (printJson resp) req 
  pure $ initResult state req'
