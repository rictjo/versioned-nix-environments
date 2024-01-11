##let
##  # use a specific (although arbitrarily chosen) version of the Nix package collection
##  default_pkgs = fetchTarball {
##    url = "http://github.com/NixOS/nixpkgs/archive/nixpkgs-unstable.tar.gz";
##    sha256 = "1h0y7gxndl3a06h0cq0k4kbbhq5jhvgh6jqzvc5qprlyakj1khhj";
##  };
### function header: we take one argument "pkgs" with a default defined above
##in { pkgs ? import default_pkgs { } }:
{ pkgs ? import <nixpkgs> { } }:
with pkgs;
with lib;
with cmake;
let
  myPy36Pkgs = python39Packages.override {
    overrides = self: super: {
      bison = super.buildPythonPackage rec {
        pname = "bison";
        version = "0.1.2";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0rh6z4g686xgzcy3k8vpkzdifqqfznylqb27n423n7fb9a5a74wv";
        };
        buildInputs = with super;
          [ pyyaml pytest-cov ];
      };
    };
  };

  
  myPyPkgsV = python310Packages.override {
    overrides = self: super: {

      skimage = super.buildPythonPackage rec {
        pname = "scikit-image" ;
        version = "0.22.0" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1nqvlljpkdrgmc3ibac27y57r7w1sg7mhyfq3v1vaka2gmqf3z23";
        };
        doCheck = false;
        buildInputs = with super;
          [ numpy pandas scipy networkx pillow imageio tifffile packaging ];
      };
    };
  };

  myPyPkgs = python39Packages.override {

    overrides = self: super: {

      devbioc = super.buildPythonPackage rec {
        name = "mybioc";
        version = "DEV";
        src = /home/rictjo/Dev/python/biocarta;
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels myPyPkgs.impetuous rpy2 umap-learn kmapper ];
      };

      jqmcvi = super.buildPythonPackage rec { # BROKEN NEEDS TO BE FIXED
        name = "jqmcvi";
        version = "DEV";
        src = /home/rictjo/Dev/python/jqm_cvi;
        nativeBuildInputs = [ cmake python39Packages.cython ];
        buildInputs = with super;
          [ numpy ];
      };

      graphtastic = super.buildPythonPackage rec {
        pname = "graphtastic";
        version = "0.12.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "023dq9s8hdn0a6562f5520ck6wnh6kxdm4hwngh7c6lnlwvnkgqw";
        };
        buildInputs = with super;
          [ numpy scipy ];
      };

      devimp = super.buildPythonPackage rec {
        name = "myimp";
        version = "DEV";
        src = /home/rictjo/Dev/python/impetuous;
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels ];
      };

      impetuous = super.buildPythonPackage rec {
        pname = "impetuous-gfa" ;
        version = "0.101.2" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1mx2g9ry01g7kdq24mkpkadcffr397cdmz1k107ga2qmk5j5axks";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels];
      };

      clustergrammer = super.buildPythonPackage rec {
        pname = "clustergrammer";
        version = "1.13.6" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0zrggqj8nzw1z2936lj1r0i1cws36nwmck89y1w6y386araasqh7";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn matplotlib ];
      };

      d3blocks = super.buildPythonPackage rec {
        pname = "d3blocks" ;
        version = "1.4.7" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0lahfkbc7haj54walydg9gf05m62xvirjs83gsw41d53dyqbw2iq";
        };
        buildInputs = with super;
          [ numpy pandas scipy matplotlib myPyPkgs.datazets ];
      };

      pypidatazets =  super.buildPythonPackage rec {
        pname = "datazets" ;
        version = "0.1.9";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "15i7mjkbad31iv4f12gd23s795j0bxxw5f8a8s3z6s3a107nsvn0";
        };
        buildInputs = with super;
          [ numpy pandas ];
      };

     vpn-slice = super.buildPythonPackage rec {
       name = "vpn-slice";
       version = "v0.13";
       src = pkgs.fetchFromGitHub {
          owner = "dlenski";
          repo = "${name}";
          rev = "${version}";
          sha256 = "1ibrwal80z27c2mh9hx85idmzilx6cpcmgc15z3lyz57bz0krigb";
       };
       propagatedBuildInputs = [ myPyPkgs.numpy myPyPkgs.toolz myPyPkgs.setproctitle ];
       meta = {
         homepage = "https://github.com/dlenski/vpn-slice";
         description = "vpnc-script replacement for easy and secure split-tunnel VPN setup";
         #license = stdenv.lib.licenses.gpl3Plus;
         maintainers = with maintainers; [ dlenski ];
       };
     };


     # $ nix-prefetch-url --unpack https://github.com/erdogant/datazets/archive/refs/tags/0.1.9.tar.gz
     # YIELDS HASH: 1n757y6y4ryddr4bjn8q47aks00rnrb5zycm17w29ac6yppj2a4f
     datazets = super.buildPythonPackage rec {
       name = "datazets";
       version = "0.1.9";
       src = pkgs.fetchFromGitHub {
          owner = "erdogant";
          repo = "${name}";
          rev = "${version}";
          sha256 = "1n757y6y4ryddr4bjn8q47aks00rnrb5zycm17w29ac6yppj2a4f";
       };
       propagatedBuildInputs = [ myPyPkgs.requests  myPyPkgs.numpy  myPyPkgs.pandas ]; #  myPyPkgs.toolz myPyPkgs.setproctitle ];
     };

     biocartograph = super.buildPythonPackage rec {
        pname = "biocartograph";
        version = "0.10.1";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1s6plshw2h6d8wlwv3f2v51f6zy8d1zzw7zg45a54ycaibf231k3";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels myPyPkgs.impetuous rpy2 umap-learn kmapper ];
     };

     GEOparse = super.buildPythonPackage rec {
        pname = "GEOparse" ;
        version = "2.0.3" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "03xx85wykx95ibiaar14w3kl4r70z9xpjnzk3fyqbqirb3qhm8ig";
        };
        doCheck = false;
        buildInputs = with super;
          [ numpy pandas scipy matplotlib dash colour tqdm tox ];
      };

     parmed = super.buildPythonPackage rec {
        pname = "ParmEd" ;
        version = "4.2.2" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1nqvlljpkdrgmc3ibac27y57r7w1sg7mhyfq3v1vaka2gmqf3z23";
        };
        doCheck = false;
        buildInputs = with super;
          [ numpy pandas scipy matplotlib ];
      };

      dashbio = super.buildPythonPackage rec {
        pname = "dash_bio" ;
        version = "1.0.2" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0dls4mk39mlq0r6md1zkv0hlypbsqa2k57sp56ag3bip590qxqkd";
        };
        doCheck = false;
        buildInputs = with super;
          [ numpy pandas scipy matplotlib dash colour periodictable 
	myPyPkgs.GEOparse biopython myPyPkgs.parmed jsonschema 
	scikit-learn tqdm ];
      };

    };
  };
  #
  pythonBundle =
    python39.withPackages (ps: with ps; [ 
      numba scikit-learn matplotlib numpy 
      ipython statsmodels kmapper
      bokeh hvplot holoviews plotly 
      beautifulsoup4 rpy2
      matplotlib bokeh seaborn
      hvplot holoviews
      datashader param colorcet
      panel pillow openpyxl imageio
      umap-learn graphviz plotly dash
      pyspark pytorch networkx flask

      python-igraph ruamel-yaml

      # test
      bison toml
      pytest pytest-cov codecov
      black memory_profiler

      xgboost
      #kaleido

 ]);

in mkShell { buildInputs = [	pythonBundle
				myPyPkgs.impetuous
                                myPyPkgs.vpn-slice
                                myPyPkgs.clustergrammer
                                #myPyPkgs.datazets
                                myPyPkgs.biocartograph
    myPyPkgs.parmed
    myPyPkgs.periodictable
    myPyPkgs.colour
    myPyPkgs.GEOparse
    myPyPkgs.biopython
    myPyPkgs.dashbio
                                #myPyPkgs.devbioc
				myPyPkgs.graphtastic ]; }
