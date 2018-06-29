{ pythonPackages, fetchFromGitHub, git, gnutar, zip }:

pythonPackages.buildPythonPackage {
  pname = "git-archive-all";
  version = "HEAD";
  src = fetchFromGitHub { 
    owner = "Kentzo";
    repo = "git-archive-all";
    rev = "master";
    sha256 = "049imj483xvhhc0dawc536kyj65qnbh7i6bm7ij07z21x49xqyry";
  };
  buildInputs = [ git zip gnutar ];
}
