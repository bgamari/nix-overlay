self: super:

let 
  unstable = 
    let
      src = self.fetchFromGitHub {
        owner = "nixos";
        repo = "nixpkgs";
        rev = "2428f5dda13475afba2dee93f4beb2bd97086930";
        sha256 = null;
      };
    in import src {};

in rec {
  inherit (import ./kicad.nix self super) kicad-symbols kicad-unstable;

  inherit (unstable) emacs26; 
  emacs = emacs26;

  # bump to 0.26.2
  notmuch = super.callPackage ./nixpkgs/pkgs/applications/networking/mailreaders/notmuch {};

  git-archive-all = super.callPackage ./git-archive-all {};

  uhk-agent = super.callPackage ./uhk-agent {};

  lattice-icecube = super.pkgsi686Linux.callPackage ./lattice-icecube {};

  slic3r = super.slic3r.overrideAttrs (oldAttrs: {
    version = "HEAD";
    src = self.fetchFromGitHub {
      owner = "alexrj";
      repo = "Slic3r";
      rev = "203f7927feeb796715044e80862908407e9ff167";
      sha256 = "10jjxiri7l5kxd30cn6vqhm6f13sp5r2zxiv4khmqgykxcrmsc1b";
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
      ipython numpy matplotlib scipy pygobject3 pyqt5 jupyter pandas sympy pint
    ]);
  };

  FlatCAM = self.callPackage (import ./FlatCAM.nix) { };

}
