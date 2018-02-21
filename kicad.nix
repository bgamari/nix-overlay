self: super:

rec {
  kicad-master = super.kicad.overrideAttrs (oldAttrs: {
    name = "kicad-master";
    version = "master";
    srcs = [
      (self.pkgs.fetchgit {
        url = "https://git.launchpad.net/kicad";
        rev = "48388695ae22195bbcc2a9a8d14e96ccfb508ec0";
        sha256 = "0wy0y40ba252draf6x3fr8aa5804m431kn252srsnfsfqif4sw6g";
        name = "kicad";
      })
      (self.pkgs.fetchFromGitHub {
        owner = "KiCad";
        repo = "kicad-library";
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

  ngspice = super.ngspice.overrideAttrs (oldAttrs: {
    configureFlags = oldAttrs.configureFlags ++ [ "--with-ngshared" ];
  });

  wx-form-builder = super.callPackage (import ./wx-form-builder.nix) { };
  ticpp = super.callPackage (import ./ticpp.nix) { };
}
