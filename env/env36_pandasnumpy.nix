let
  # use a specific (although arbitrarily chosen) version of the Nix package collection
  default_pkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-19.03.tar.gz"; 
    sha256 = "11z6ajj108fy2q5g8y4higlcaqncrbjm3dnv17pvif6avagw4mcb";
  };
in { pkgs ? import default_pkgs { } }:
with pkgs;
let
  pythonBundle =
    python36.withPackages (ps: with ps; [ numpy pytz python-dateutil nose pytest ]);

  # v0.21.1 (December 12, 2017)
  myPy36Pkgs = python36Packages.override {
    overrides = self: super: {
      pandas = super.buildPythonPackage rec {
        pname = "pandas";
        version = "0.21.1";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "12kqz67v74inl8lmlcd9iz76z7qkg0grx40wqia9arghiflcpxf5";
        };
        doCheck = false;
        buildInputs = with super;
          [ numpy pytz python-dateutil nose pytest ];
      };
    };
  };

in mkShell { buildInputs = [ pythonBundle
			 myPy36Pkgs.pandas
	]; }
