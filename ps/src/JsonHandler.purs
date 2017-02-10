module JsonHandler (init, terminate) where

import Prelude
import Erl.Data.List (nil, (:))
import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (Ok, Req, StatusCode(..), ok, path, qs, reply)
import Erl.Data.Jsone (jsonEmptyObject)
import Erl.Data.Jsone.Encode.Combinators ((~>), (:=))
import Erl.Data.Jsone.Printer (printJson)
import Erl.Data.Tuple (Tuple3, tuple2, tuple3)

infixl 6 tuple2 as ~~>

init :: forall a. Req -> a -> Tuple3 Ok Req Unit
init req _ = handle req unit

terminate :: forall a b c. a -> b -> c -> Ok
terminate _ _ _ = ok

handle :: forall a. Handler a
handle req state =
  let headers = "content-type" ~~> "application/json" : nil
      resp = ( "path" := path req
            ~> "query" := qs req
            ~> jsonEmptyObject )
      req' = reply (StatusCode 200) headers (printJson resp) req
  in tuple3 ok req' state
