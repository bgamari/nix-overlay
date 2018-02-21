{ stdenv, fetchFromGitHub, wxGTK30, boost, ticpp }:

stdenv.mkDerivation rec {
  name = "wx-form-builder-${version}";
  version = "3.6.0.20171103";
  src = fetchFromGitHub {
    owner = "wxFormBuilder";
    repo = "wxFormBuilder";
    rev = "1a609ee9630894864a3200331b58560d701d823f";
    sha256 = "0admm2a9z61wnvnrp2g6jgpk7c5lm852il71xfd8mygkvs9k97wj";
  };
  enableParallelBuilding = true;
  buildInputs = [ wxGTK30 boost ticpp ];
  configurePhase = '' 
    ./create_build_files4.sh -rpath ${ticpp}/lib
    cd build/3.0/gmake
  '';
  makeFlags = '' config=release '';
  installPhase = '' cp ../../../output/bin $out '';
}
