let
  #pkgs = import /home/ben/nixpkgs {
  pkgs = import <nixpkgs> {
    overlays = [ (import ./overlay.nix) ];
  };
in pkgs
