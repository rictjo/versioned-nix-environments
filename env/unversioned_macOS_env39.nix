with (import <nixpkgs> {}).pkgs;
with pkgs;
with lib;
with cmake;
let
myPyPkgs = python39Packages.override {

  overrides = self: super: {

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

    impetuous = super.buildPythonPackage rec {
      pname = "impetuous-gfa" ;
      version = "0.101.15" ;
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "tE1ktjJzAZXw0LfGMz5IR9nFrXyDnbMZh0emA0N7L74=";
      };
      buildInputs = with super;
        [ numpy pandas scipy scikit-learn statsmodels ];
    };
      
    biocartograph = super.buildPythonPackage rec {
      pname = "biocartograph";
      version = "0.10.20";
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "+XM48Ne42CDfziSpGBbn4A0QF2eIAkl2PvTxSoBZK6Q=";
      };
      buildInputs = with super;
        [ numpy pandas scipy scikit-learn statsmodels myPyPkgs.impetuous rpy2 umap-learn ];
    };

    counterpartner = super.buildPythonPackage rec {
      pname = "counterpartner";
      version = "0.10.2";
      src = super.fetchPypi { 
        inherit pname version;
        sha256 = "3QKf+0RD5ud6pbCqvVqc5mc1BBQATMSAJ1Lgy3wqzGk=";
      };
      doCheck = false;
      buildInputs = with super;
        [ numpy scipy scikit-learn ];
    };

    missforest = super.buildPythonPackage rec {
      pname = "missingforest";
      version = "0.4.1";
      src = super.fetchPypi {
        inherit pname version;
        sha256 = "D7adq67O4XisLTqXaadQfCXXenv/oSPZMgGydze5lFM=";
      };
      doCheck = false;
      buildInputs = with super;
        [ numpy scipy scikit-learn ];
    };
  };
};

pythonBundle = python39.withPackages (ps: with ps; [ 
  scikit-learn matplotlib numpy numba umap-learn
  # jax jaxlib
  statsmodels seaborn matplotlib ]);

in mkShell { buildInputs = [ pythonBundle
myPyPkgs.impetuous
myPyPkgs.biocartograph
#myPyPkgs.missforest
#myPyPkgs.counterpartner
#myPyPkgs.graphtastic

texlive.combined.scheme-full 
mupdf
]; }
