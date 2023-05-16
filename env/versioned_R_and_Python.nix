#
# FUNCTIONALLY DEFINED ENVIRONMENT BY THE 
# nixos.org PEOPLE
#
# BELOW IS THE VERSION CONTROLLED ENVIRONMENT FOR
# RUNNING DEDICATED CODES AS OF 2023-05-XX
# https://nixos.org/download.html
# DOWNLOAD THE PACKAGE NIX ON ANY SYSTEM AND INSTALL IT
# THEN ENTER THIS ENVIRONMENT VIA
# $ nix-shell versioned_R_and_Python.nix
#
# TYPICAL USUAL INSTALLATIONS CAN USUALLY BE DONE BY RUNNING
# $ sh <(curl -L https://nixos.org/nix/install) --no-daemon
#
# YOU CAN ALSO DOWNLOAD A DOCKER IMAGE
#
let
  default_pkgs = fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-22.11.tar.gz"; 
    sha256 = "12q3hsflxx1jiffja0w3a71f95vj64dbjwdfh4g8hfh0npzfk0z4";
  };
in { pkgs ? import default_pkgs { } }:
with pkgs;
let
  myRBundle = rWrapper.override {
    packages = with rPackages; [
      rstudio shiny hexbin
      R6 sf tm ape sp
      propr magrittr pander
      markdown rsconnect packrat
      tximport tximeta
      factoextra Seurat plotly aricode
      clValid infotheo clue 
      dbscan fpc concaveman

      ggplot2 biomaRt 
      ggwordcloud ggforce ggdendro
      ggbeeswarm ggrepel ggridges
      ggalluvial gtable ggraph Cairo
      ggthemes ggrastr ggheatmap

      svglite

      biomaRt BiocManager clusterProfiler
      NOISeq enrichR edgeR
      Hmisc umap pheatmap uwot
      dendextend ellipse  rrvgo
      pcaMethods viridis pathview

      tidyverse tidygraph tidytext multidplyr

      pbapply treemapify patchwork 
      igraph concaveman gridExtra 
      broom FNN mgsub

      reticulate devtools V8 coda rstan

      parallelly
      
    ];
  };
  #
  myPythonBundle = python39.withPackages (ps : with ps;[ numpy pandas scipy umap-learn pip rpy2 statsmodels kmapper scikit-learn ]);
  #
  myPyPkgs = python39Packages.override {
    overrides = self: super: {
    #
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
    #
      impetuous = super.buildPythonPackage rec {
        pname = "impetuous-gfa" ;
        version = "0.97.50" ;
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "0d583mzbalyy1jrj3yk3myb9d8bcyg2982kcryyh8021qsiq35bv";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels ];
      };
    #
      biocartograph = super.buildPythonPackage rec {
        pname = "biocartograph";
        version = "0.5.0";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "1i2vn3b6378yaqz88qraf57p6qwraigfncbajvdy6j74crx4zd4i";
        };
        buildInputs = with super;
          [ numpy pandas scipy scikit-learn statsmodels myPyPkgs.impetuous rpy2 umap-learn kmapper ];
      };
    #
    };
  };

in mkShell { buildInputs = [ # HERE WE ADD IN ANY LIBRARIES WE THINK WE MIGHT NEED
   git glibcLocales freetype.dev harfbuzz.dev fribidi openssl which openssh curl wget 
   myRBundle myPythonBundle
   myPyPkgs.impetuous
   myPyPkgs.biocartograph 
   graphviz
]; 
  shellHook = ''
    mkdir -p "$(pwd)/_libs"              # BUILD A LIBRARY THAT R WILL FIND IN THE CURRENT DIRECTORY
    export R_LIBS_USER="$(pwd)/_libs"
  '';
}
