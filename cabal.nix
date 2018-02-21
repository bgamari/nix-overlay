self: super:

let
  haskellPackages = super.haskell.packages.ghc822;
  inherit (super.haskell.lib) doJailbreak dontCheck;
  hackage-security =
    let
      src = super.fetchFromGitHub {
        owner = "haskell";
        repo = "hackage-security";
        rev = "master";
        sha256 = null;
      };
    in dontCheck (doJailbreak (haskellPackages.callCabal2nix "hackage-security" "${src}/hackage-security" { inherit Cabal; }));

  src = super.fetchFromGitHub {
    owner = "haskell";
    repo = "cabal";
    rev = "master";
    sha256 = null;
  };

  Cabal = haskellPackages.callCabal2nix "Cabal" "${src}/Cabal" { };

  cabal-install = haskellPackages.callCabal2nix "cabal-install" "${src}/cabal-install" { inherit Cabal hackage-security; };

in cabal-install
