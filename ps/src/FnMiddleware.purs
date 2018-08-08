module FnMiddleware where

import Prelude

import Effect (Effect)
import Effect.Unsafe (unsafePerformEffect)
import Erl.Atom (Atom, atom)
import Erl.Cowboy (ProtoEnv(..), ProtocolEnv)
import Erl.Cowboy.Req (Req)
import Erl.Data.Tuple (Tuple3, tuple3)

execute :: Req -> ProtocolEnv -> Tuple3 Atom Req ProtocolEnv
execute req env = unsafePerformEffect $ do
  -- traverse_ onReq env
  pure $ tuple3 (atom "ok") req env

  where
    onReq :: ProtoEnv -> Effect Unit
    onReq (Fn f) = f
    onReq _ = pure unit
