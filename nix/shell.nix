{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, bytestring, containers, deepseq
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
          base doctest hedgehog QuickCheck tasty tasty-hedgehog
          tasty-quickcheck
        ];
        homepage = "http://github.com/sboosali/rank2#readme";
        description = "TODO";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
