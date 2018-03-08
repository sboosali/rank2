
{-# OPTIONS_GHC -fno-warn-missing-signatures #-} -- to test inference

{-| This module provides an example program. 
Please read the source too <https://hackage.haskell.org/package/rank2/docs/src/Rank2-Example.html (direct Hackage link)>. 

Being a @library@ module, it's typechecked with the package, 
and thus should always build.

Only public interfaces are imported (i.e. no @.Internal@s),
and there are minimal other dependencies. 

'main' is executed by the @rank2-example@ executable. 

-}
module Rank2.Example where

import Rank2()

import System.Environment

import Prelude

{-|

Running:

@
cabal build && cabal run example-rank2
@

@
stack build && stack exec -- example-rank2
@

-}
main :: IO ()
main = do
 arguments <- getArgs >>= \case
  [s] -> return (s)
  _ -> return ("")
 mainWith arguments

mainWith s = do
 putStrLn s
 putStrLn "(Rank2.Example...)"

