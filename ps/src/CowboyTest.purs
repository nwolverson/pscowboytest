module CowboyTest where

import Prelude
import Erl.Cowboy.Req.Monad as ReqM
import Erl.Cowboy.Handler (Handler)
import Erl.Cowboy.Req (path, qs, reply, StatusCode(..), ok)
import Erl.Data.Jsone (jsonEmptyObject)
import Erl.Data.Jsone.Encode.Combinators ((~>), (:=))
import Erl.Data.Jsone.Printer (printJson)
import Erl.Data.List (nil, (:))
import Erl.Data.Tuple (Tuple2, tuple2, tuple3)

header :: String -> String -> Tuple2 String String
header = tuple2

infixl 6 header as ~~>

handler :: forall a. Handler a
handler req state =
  let headers = tuple2 "content-type" "text/plain" : nil
      response = "Hello! path is " <> path req <> " and query string is " <> qs req
      req' = reply (StatusCode 200) headers response req
  in tuple3 ok req' state

handlerJson :: forall a. Handler a
handlerJson req state =
  let headers = tuple2 "content-type" "application/json" : nil
      resp = ( "path" := path req
            ~> "query" := qs req
            ~> jsonEmptyObject )
      req' = reply (StatusCode 200) headers (printJson resp) req
  in tuple3 ok req' state

handlerM :: forall a. Handler a
handlerM = ReqM.handler $ do
  let headers = "content-type" ~~> "text/plain" : nil
  path <- ReqM.path
  qs <- ReqM.qs
  let response = "Hello! Path is " <> path <> " and query string is " <> qs
  ReqM.reply (StatusCode 200) headers response
