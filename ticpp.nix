{ stdenv, fetchFromGitHub, cmake, tinyxml }:

stdenv.mkDerivation rec {
  name = "ticpp-${version}";
  version = "0.20171103";
  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "ticpp";
    rev = "9f0b61df3b220fcaec1d820461c343f064124c48";
    sha256 = "113h6a0kr4ywxna822m40fy1rss0xman9p3346lmlrq3g8wzbz1y";
  };
  makeFlags = "CONFIG=Release";
  nativeBuildInputs = [ cmake ];
  buildInputs = [ tinyxml ];
  installPhase = ''
    mkdir -p $out/include $out/lib
    cp libticpp.a $out/lib
    cp $src/ticpp.h $src/ticppapi.h $src/ticpprc.h $src/tinyxml.h $out/include
  '';
}
