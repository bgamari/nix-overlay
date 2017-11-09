self: super:

rec {
  kicad-master = super.kicad.overrideAttrs (oldAttrs: {
    name = "kicad-master";
    version = "master";
    srcs = [
      (self.pkgs.fetchgit {
        url = "https://git.launchpad.net/kicad";
        rev = "e5c4cfc3b01724de705609c901575b40cd3958b4";
        sha256 = "1hb4hj4rx29lab0gkgw02df6snl3k2bk5aizc14ali6x8cvrc1cj";
        name = "kicad";
      })
      (self.pkgs.fetchgit {
        url = "git@github.com:KiCad/kicad-library.git";
        rev = "5672f4347a045362986824926eff7bbcbb289080";
        sha256 = "14agy64rl63hpsdn9hjhl5j8hzh28fma018w1sfxgnax164nywz1";
        name = "kicad-library-head";
      })
    ];
    sourceRoot = "kicad";
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ self.pkgs.swig ];
    buildInputs = oldAttrs.buildInputs ++ [ self.pkgs.ngspice self.pkgs.glm self.pkgs.python ];
    cmakeFlags = oldAttrs.cmakeFlags + ''
      -DKICAD_SPICE=ON
      -DKICAD_SCRIPTING=ON
      -DKICAD_SCRIPTING_MODULES=ON
    '';
    postInstall = ''
      popd

      chmod -R ug+w .
      pushd kicad-library-*
      cmake -DCMAKE_INSTALL_PREFIX=$out
      make $MAKE_FLAGS
      make install
      popd
    '';
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

  ngspice = super.ngspice.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--with-ngshared" ];
  });
}

