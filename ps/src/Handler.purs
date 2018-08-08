module Handler (init, terminate) where

import Prelude
import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (Ok, Req, StatusCode(..), ok, path, qs, reply)
import Erl.Data.Tuple (Tuple3, tuple3)
import Erl.Data.Map as M

init :: forall a. Req -> a -> Tuple3 Ok Req Unit
init req _ = handle req unit

terminate :: forall a b c. a -> b -> c -> Ok
terminate _ _ _ = ok

handle :: forall a. Handler a
handle req state =
  let headers = M.singleton "content-type" "text/plain"
      response = "Hello! path is " <> path req <> " and query string is " <> qs req
      req' = reply (StatusCode 200) headers response req
  in tuple3 ok req' state
