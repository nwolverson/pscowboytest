module JsonHandler (init, terminate) where

import Prelude

import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (Ok, Req, StatusCode(..), ok, path, qs, reply)
import Erl.Data.Jsone (jsonEmptyObject)
import Erl.Data.Jsone.Encode.Combinators ((~>), (:=))
import Erl.Data.Jsone.Printer (printJson)
import Erl.Data.Map as M
import Erl.Data.Tuple (Tuple3, tuple3)

init :: forall a. Req -> a -> Tuple3 Ok Req Unit
init req _ = handle req unit

terminate :: forall a b c. a -> b -> c -> Ok
terminate _ _ _ = ok

handle :: forall a. Handler a
handle req state =
  let headers = M.singleton "content-type" "application/json"
      resp = ( "path" := path req
            ~> "query" := qs req
            ~> jsonEmptyObject )
      req' = reply (StatusCode 200) headers (printJson resp) req
  in tuple3 ok req' state
