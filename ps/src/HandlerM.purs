module HandlerM (init, terminate) where

import Prelude

import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (Ok, Req, StatusCode(StatusCode), ok)
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Data.Map as M
import Erl.Data.Tuple (Tuple3)

init :: forall a. Req -> a -> Tuple3 Ok Req Unit
init req _ = handlerM req unit

terminate :: forall a b c. a -> b -> c -> Ok
terminate _ _ _ = ok

handlerM :: forall a. Handler a
handlerM = ReqM.handler $ do
  let headers = M.singleton "content-type" "text/plain"
  path <- ReqM.path
  qs <- ReqM.qs
  let response = "Hello! Path is " <> path <> " and query string is " <> qs
  ReqM.reply (StatusCode 200) headers response
