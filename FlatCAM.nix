{ fetchgit, python2Packages }:

python2Packages.buildPythonPackage {
  name = "FlatCAM";
  src = fetchgit {
    url = "https://bitbucket.org/jpcgt/flatcam.git";
    rev = "3eec5132c381d4c6f35e680ebb9826f5f051229b";
    sha256 = null;
  };
  propagatedBuildInputs = with python2Packages;
    [ scipy matplotlib shapely svg-path simplejson pyqt4 tkinter Rtree ];
  doCheck = false; # Requires X session
}
