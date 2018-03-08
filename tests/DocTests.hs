{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
import Test.DocTest       (doctest)
import System.Environment (getArgs)

----------------------------------------

main = do
  arguments <- getArgs
  
  doctest $ sources ++ extensions ++ arguments

----------------------------------------

sources =
 [ "sources/" 
 ] 

extensions = extensions2flags "NoImplicitPrelude PackageImports AutoDeriveTypeable DeriveDataTypeable DeriveGeneric DeriveFunctor DeriveFoldable DeriveTraversable LambdaCase EmptyCase TypeOperators PostfixOperators ViewPatterns BangPatterns KindSignatures NamedFieldPuns RecordWildCards TupleSections MultiWayIf DoAndIfThenElse EmptyDataDecls InstanceSigs MultiParamTypeClasses FlexibleContexts FlexibleInstances TypeFamilies FunctionalDependencies ScopedTypeVariables StandaloneDeriving"
  where
  extensions2flags :: String -> [String]
  extensions2flags = fmap ("-X"++) . words

----------------------------------------

