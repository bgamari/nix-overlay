self: super:

rec {
  inherit (import ./kicad.nix self super) kicad-master ngspice;
  inkscape-master = super.inkscape.overrideAttrs (oldAttrs: {
    name = "inkscape-master";
    version = "master";
    src = self.pkgs.fetchgit {
      url = "https://git.launchpad.net/kicad";
      rev = "e5c4cfc3b01724de705609c901575b40cd3958b4";
      sha256 = "08qrz5zzsb5127jlnv24j0sgiryd5nqwg3lfnwi8j9a25agqk13j";
        name = "inkscape";
    };
    sourceRoot = "inkscape";
  });

  emacs26 = super.emacs.overrideAttrs (oldAttrs: {
    src = self.fetchurl {
      url = "ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-26.0.91.tar.xz";
      sha256 = "1841hcqvwnh812gircpv2g9fqarlirh7ixv007hkglqk7qsvpxii";
    };
    patches = [];
  });

  pandoc = super.haskellPackages.callHackage "pandoc" "2.0.1" {};

  # ESP32
  esp32-toolchain = super.callPackage (import esp32/espressif-toolchain.nix) { };
  inherit (esp32-toolchain) gcc-xtensa binutils-xtensa;
  #espressif-toolchain = super.callPackage (import esp32/crosstool-ng-esp32.nix) { };
  micropython-esp32 = super.callPackage (import esp32/micropython-esp32.nix) { };

  srain = super.stdenv.mkDerivation {
    name = "srain";
    src = super.fetchFromGitHub {
      owner = "SilverRainZ";
      repo = "srain";
      rev = "0.06.3";
      sha256 = null;
    };
    configureFlags = [ "--prefix=$(out)" "--config-dir=$(out)/etc" ];
    nativeBuildInputs = with super; [ pkgconfig libxml2 imagemagick gettext ];
    buildInputs = with super; [ glib gtk3 curl python3 python3Packages.requests libnotify libconfig libsoup ];
  };
}

