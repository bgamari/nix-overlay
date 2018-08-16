self: super:

rec {
  inherit (import ./kicad.nix self super) kicad-symbols;

  git-archive-all = super.callPackage ./git-archive-all {};

  uhk-agent = super.callPackage ./uhk-agent {};

  slic3r = super.slic3r.overrideAttrs (oldAttrs: {
    version = "HEAD";
    src = self.fetchFromGitHub {
      owner = "alexrj";
      repo = "Slic3r";
      rev = "4f3e89a871a03f00c97354557676270de7605074";
      sha256 = "026yrfvmb0g20wa7xql33mzjj4aal4n4whqa83phc7m5299imvri";
    };
    patches = [ ./slic3r-fix-include.patch ];
    buildInputs = with self.perlPackages; [ perl self.makeWrapper self.which self.boost
      ExtUtilsCppGuess ModuleBuildWithXSpp EncodeLocale MathClipper ExtUtilsXSpp threads
      MathConvexHullMonotoneChain MathGeometryVoronoi MathPlanePath Moo
      ExtUtilsTypemapsDefault
      IOStringy ClassXSAccessor Wx GrowlGNTP NetDBus ImportInto XMLSAX
      ExtUtilsMakeMaker OpenGL WxGLCanvas ModuleBuild LWP DevelChecklib
      locallib
    ];
  });

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

  openscad = super.openscad.overrideAttrs (oldAttrs: {
    src = super.fetchFromGitHub {
      owner = "openscad";
      repo = "openscad";
      rev = "8a2d62d2e5216f0954139a89a201d998ad2268f8";
      sha256 = null;
    };
  });

  emacs26 = super.emacs.overrideAttrs (oldAttrs: {
    src = self.fetchurl {
      url = "ftp://alpha.gnu.org/gnu/emacs/pretest/emacs-26.0.91.tar.xz";
      sha256 = "1841hcqvwnh812gircpv2g9fqarlirh7ixv007hkglqk7qsvpxii";
    };
    patches = [];
  });

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
      rev = "0.06.4";
      sha256 = null;
    };
    configureFlags = [ "--prefix=$(out)" "--config-dir=$(out)/etc" ];
    nativeBuildInputs = with super; [ pkgconfig libxml2 imagemagick gettext ];
    buildInputs = with super; [ glib gtk3 curl python3 python3Packages.requests libnotify libconfig libsoup ];
  };

  ward = 
    let src = self.fetchFromGitHub {
          owner = "evincarofautumn";
          repo = "Ward";
          rev = "05b02cf2a617886d5c064648d2ce415aa9043c86";
          sha256 = null;
        };
    in self.haskellPackages.callCabal2nix "ward" src {};

  cabal-install-head = import ./cabal.nix self super;

  ben = {
    scipyEnv = self.python3.withPackages (ps: with ps; [
      ipython numpy matplotlib scipy pygobject3 pyqt5 jupyter
    ]);
  };

  FlatCAM = self.callPackage (import ./FlatCAM.nix) { };

}
