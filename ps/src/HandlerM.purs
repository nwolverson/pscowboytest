module HandlerM (init, terminate) where

import Prelude
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (Ok, Req, StatusCode(StatusCode), ok)
import Erl.Data.List (nil, (:))
import Erl.Data.Tuple (Tuple3, tuple2)

infixl 6 tuple2 as ~~>

init :: forall a. Req -> a -> Tuple3 Ok Req Unit
init req _ = handlerM req unit

terminate :: forall a b c. a -> b -> c -> Ok
terminate _ _ _ = ok

handlerM :: forall a. Handler a
handlerM = ReqM.handler $ do
  let headers = "content-type" ~~> "text/plain" : nil
  path <- ReqM.path
  qs <- ReqM.qs
  let response = "Hello! Path is " <> path <> " and query string is " <> qs
  ReqM.reply (StatusCode 200) headers response
