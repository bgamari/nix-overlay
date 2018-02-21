let
  pkgs = import ./nixpkgs {
  #pkgs = import <nixpkgs> {
    overlays = [ (import ./overlay.nix) ];
  };
in pkgs
