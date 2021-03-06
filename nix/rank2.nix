{ mkDerivation, base, bytestring, containers, criterion, deepseq
, doctest, exceptions, hashable, hedgehog, lens, mtl, QuickCheck
, spiros, stdenv, tasty, tasty-hedgehog, tasty-quickcheck, text
, transformers, unordered-containers
}:
mkDerivation {
  pname = "rank2";
  version = "0.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    base bytestring containers deepseq exceptions hashable lens mtl
    spiros text transformers unordered-containers
  ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [
    base doctest hedgehog lens QuickCheck tasty tasty-hedgehog
    tasty-quickcheck
  ];
  benchmarkHaskellDepends = [ base criterion deepseq ];
  homepage = "http://github.com/sboosali/rank2#readme";
  description = "TODO";
  license = stdenv.lib.licenses.bsd3;
}
