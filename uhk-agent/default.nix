{fetchurl}:

let
  version = "1.2.5";

  image = nixpkgs.stdenv.mkDerivation {
    name = "uhk-agent-image";
    src = fetchurl {
      url = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
      sha256 = "1skwzw13c4w5yk79hsqsrxpp4i630d5hxx23wsh2psn9ivm7av0j";
    };
    buildCommand = ''
      mkdir -p $out
      cp $src $out/appimage
      chmod ugo+rx $out/appimage
    '';
  };

  nixpkgs =
    let base = (import <nixpkgs> {}).fetchFromGitHub {
          owner = "nixos";
          repo = "nixpkgs";
          rev = "0c083fc1f6a653d6aa0f5eacef1905f00cf412d6";
          sha256 = null;
        };
    in import base {};

in nixpkgs.writeScriptBin "uhk-agent" ''
  ${nixpkgs.appimage-run}/bin/appimage-run ${image}/appimage
''
