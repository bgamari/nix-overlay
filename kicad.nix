self: super:

rec {
  kicad-unstable = super.kicad.overrideAttrs (oldAttrs: {
    src = /home/ben/kicad-source-mirror;
    cmakeFlags = oldAttrs.cmakeFlags ++
      [ "-DCMAKE_CXX_FLAGS=-I${super.pythonPackages.wxPython30}/include/wx-3.0" ];
  });

  kicad-symbols = super.stdenv.mkDerivation {
    name = "kicad-symbols";
    nativeBuildInputs = [ self.cmake ];
    src = self.pkgs.fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-symbols";
      rev = "08b67f0020ea9f703adc7f45a921df9d0f1106bd";
      sha256 = "1qfmw75aqr6kpd30lkyshc500vz2xf6gv1naznqw396nra2nc7n0";
      name = "kicad-symbols";
    };
  };

  kicad-packages3D = super.stdenv.mkDerivation {
    name = "kicad-packages3D";
    nativeBuildInputs = [ self.cmake ];
    src = self.pkgs.fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-packages3D";
      rev = "48fcd1fa6ab91ffb1067776972a5be191adcf8d0";
      sha256 = "0sra2vn37ppw8x7dza3qb9ws4drdc1927h94ijbp91gamdak5sbj";
      name = "kicad-packages3D";
    };
  };

  kicad-templates = super.stdenv.mkDerivation {
    name = "kicad-templates";
    nativeBuildInputs = [ self.cmake ];
    src = self.pkgs.fetchFromGitHub {
      owner = "KiCad";
      repo = "kicad-templates";
      rev = "49661c89c7e21073f0c29caaadaf20ac3733dbba";
      sha256 = "0xg73q21f1w79q8vx8lvx09qqj396cynpdrmf6kgkcp7yjp7xz9x";
      name = "kicad-templates";
    };
  };

  wx-form-builder = super.callPackage (import ./wx-form-builder.nix) { };
  ticpp = super.callPackage (import ./ticpp.nix) { };
}
