
{ nixpkgs ? import <nixpkgs> {}

, compiler ? "default"

, doTest        ? true
, doBenchmark   ? false

, withProfiling ? if doBenchmark then true else false
, withHoogle    ? true 

, development   ? true
}:

/* Usage:

  nix-shell
  cabal configure 
  cabal build
  cabal run

*/

########################################
let

### "IMPORTS"

inherit (nixpkgs) pkgs;
inherit (pkgs)    fetchFromGitHub;

lib = import "${nixpkgs.path}/pkgs/development/haskell-modules/lib.nix" { pkgs = nixpkgs; };
haskell = nixpkgs.haskell.lib;
#haskell = lib;
hs = pkgs.haskell.lib; #TODO rm

in
########################################
let

### UTILITIES

skipTests       = haskell.dontCheck; 
dropUpperBounds = haskell.doJailbreak;

cabal2nixResult = options: src:
  nixpkgs.runCommand "cabal2nixResult" {
    buildCommand = ''
      cabal2nix ${options} file://"${src}" >"$out"
    '';
    buildInputs = with nixpkgs; [
      cabal2nix
    ];
  } "";

in
########################################
let

### SOURCE OVERRIDES

# "megarepos" which have multiple packages as subdirectories.
repositories = {
};

sources = {
};

in
########################################
let

### COMPILERS

haskellPackagesWithCompiler = 
  if compiler == "default"
  then pkgs.haskellPackages
  else pkgs.haskell.packages.${compiler};

haskellPackagesWithProfiling = 
  if withProfiling
  then haskellPackagesWithCompiler.override {
         overrides = self: super: {
           mkDerivation = args: super.mkDerivation (args // { enableLibraryProfiling = true; });
         };
       }
  else haskellPackagesWithCompiler;
                 
haskellPackagesWithHoogle =
  if withHoogle
  then haskellPackagesWithProfiling.override {
         overrides = self: super: {
           ghc = super.ghc // { withPackages = super.ghc.withHoogle; };
           ghcWithPackages = self.ghc.withPackages;
         };
       }
  else haskellPackagesWithProfiling;

in

########################################
### Haskell Dependencies...
let

/*

NOTES

* `local` / `github`: 
   They call `import` directly, thus those directories require a `default.nix`
* `cabal2nix` / `hackage` / `github2nix`: 
   They call `cabal2nix`, which generates the `default.nix`, so they don't require the given directory to be a valid `nix` package. 

*/
myHaskellOverlaysWith = self: super: let
#myHaskellOverlaysWith = pkgs: self: super: let

 local      = path:
              self.callPackage path; 

 github     = o:
              self.callPackage (pkgs.fetchFromGitHub o); 

             # o ::
             #      { owner           :: String
             #        repo            :: String
             #        rev             :: String
             #        fetchSubmodules :: Bool
             #        sha256          :: String
             #      } 

 cabal2nix  = name: source: 
              self.callCabal2nix name source;

 hackage    = name: version:
              self.callHackage name version;

 github2nix = o:
              cabal2nix o.repo (pkgs.fetchFromGitHub o); 

 # override the package without overriding any dependencies
 local_      = path:           local      path         {};
 github_     = o:              github     o            {};
 cabal2nix_  = name: source:   cabal2nix  name source  {};
 hackage_    = name: version:  hackage    name version {};
 github2nix_ = o:              github2nix o            {};

 in

 {
   ########################################
   # Add Haskell Packages Below           #
   ######################################## 

   spiros = local_ ../spiros;

    # spiros = github2nix_ {
    #   owner  = "sboosali";
    #   repo   = "spiros";
    #   rev    = "f6c86509cfa1b198c5deb4b89b3dadf6184ea1d0"; 
    #   sha256 = "0bvxgp1mvlpwzr9qdpjs20qs4i813wnhrsl3nq25r8v68x6fblhk";
    # };
      # NOTE
      # latest needs ghc-8.2.2
      # rev "2b7517f27242863ba153bc045dd269b348df05aa" 

 /* 

  # You can use `callHackage` and `callCabal2nix` 
  # to bump package versions or build them from GitHub. 
  # e.g.

    spiros = self.spiros_loose;

    spiros_loose   = skipTests (dropUpperBounds self.spiros_github);
    spiros_local   = local ../spiros {
    };
    spiros_hackage = hackage "spiros" "0.0.0" {
    };
    spiros_github  = github2nix {
      owner  = "sboosali";
      repo   = "spiros";
      rev    = "f6c86509cfa1b198c5deb4b89b3dadf6184ea1d0"; 
      # "2b7517f27242863ba153bc045dd269b348df05aa" 
      # latest needs ghc-8.2.2
      sha256 = 
         "0bvxgp1mvlpwzr9qdpjs20qs4i813wnhrsl3nq25r8v68x6fblhk";
    } {
    };
 */

};

in
########################################
let

### OTHER OVERRIDES

modifiedHaskellPackages = haskellPackagesWithHoogle.override {
  overrides = myHaskellOverlaysWith;
};

in
########################################
let

### DERIVATION / ENVIRONMENT

installationDerivation = modifiedHaskellPackages.callPackage ./. {};

# development environment
# for `nix-shell --pure`
developmentDerivation = hs.linkWithGold 
    (hs.addBuildDepends installationDerivation developmentPackages);

developmentPackages = developmentHaskellPackages
                   # ++ developmentEmacsPackages 
                   ++ developmentSystemPackages;

developmentSystemPackages = with pkgs; [
  
 cabal-install

 coreutils
 inotify-tools
  
 emacs
 git

];

developmentHaskellPackages = with modifiedHaskellPackages; [
  
 # ghcid
 # ghc-mod

 stylish-haskell
 hasktags
 present
 hlint
 hoogle
 hindent
  
];

 # developmentHaskellPackages = with Packages; [
 #    dante
 #  ];

environment = hs.shellAware developmentDerivation;
   # if pkgs.lib.inNixShell then drv.env else drv;

in
########################################

environment

########################################
/*

, withEverything ? true # false

, withProfiling ? if withEverything then true else true
, withHoogle    ? if withEverything then true else true 

, doTest        ? if withEverything then true else true
, doBenchmark   ? if withEverything then true else true



*/
