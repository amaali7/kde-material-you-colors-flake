{
  description = "Just some python scripts to download books.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: {
    devShell = self.defaultPackage;
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      let
        libgenApi = pkgs.python3Packages.buildPythonPackage rec {
          pname = "kde-material-you-colors";
          version = "1.9.1";
          doCheck = false;
          propagatedBuildInputs = with pkgs.python3Packages; [
            setuptools
            wheel
	          beautifulsoup4
	        ];
          src = (pkgs.python3Packages.fetchPypi {
            inherit pname version;
            sha256 = "08fdd5ef7c96480ad11c12d472de21acd32359996f69a5259299b540feba4560";
        });};
      in
        pkgs.python3Packages.buildPythonPackage rec {
          name = "getBook";
          src = ./.;
          propagatedBuildInputs = with pkgs.python3Packages; [
            libgenApi
          ];
        };
  };
}
