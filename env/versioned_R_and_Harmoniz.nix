#
# FUNCTIONALLY DEFINED ENVIRONMENT FOR THE PACKAGE
# MANAGER AND OPERATING SYSTEM BY nixos.org PEOPLE
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
# https://lazamar.co.uk/nix-versions/?package=R&version=4.3.1&fullName=R-4.3.1&keyName=R&revision=9957cd48326fe8dbd52fdc50dd2502307f188b0d
#	&channel=nixpkgs-unstable#instructions
# https://lazamar.co.uk/nix-versions/?package=R&version=4.1.2&fullName=R-4.1.2&keyName=R
#	&revision=7592790b9e02f7f99ddcb1bd33fd44ff8df6a9a7&channel=nixos-22.11#instructions
#
let
  default_pkgs = fetchTarball {
        url = "https://github.com/NixOS/nixpkgs/archive/9957cd48326fe8dbd52fdc50dd2502307f188b0d.tar.gz";
        sha256="1l2hq1n1jl2l64fdcpq3jrfphaz10sd1cpsax3xdya0xgsncgcsi";
    };
in { pkgs ? import default_pkgs { } }:
with pkgs;
let
  pmt = pkgs.rPackages.buildRPackage {
    name = "pmt";
    src = pkgs.fetchFromGitHub {
      owner = "jbedo";
      repo = "pmt";
      rev = "f5af7ada6f419382415335f5ae283f8a4643f79c";
      sha256 = "ODIRNRKsqBOqrOINQpOBOET5izKmhnp2F8DCVl4BOQI=";
    };
  };
  hrmR = pkgs.rPackages.buildRPackage {
    name = "harmonizR";
    src = pkgs.fetchFromGitHub {
      owner     = "HSU-HPC";		#"SimonSchlumbohm";
      repo      = "harmonizR";		# git rev-parse HEAD
      rev       = "dcb7efd3ce2663ff7e35f96f40feadad5ad4a480";
      sha256    = "1w7w3d660wjpymgzsq1dmlr1s4a95q8bjm611bi4rxxhl0gf7isp";
    };
    buildInputs = [ pkgs.R pkgs.rPackages.doParallel pkgs.rPackages.sva 
	pkgs.rPackages.plyr pkgs.rPackages.janitor pkgs.rPackages.limma
	pkgs.rPackages.seriation pkgs.rPackages.SummarizedExperiment ];
  };

  myRBundle = rWrapper.override {
    packages = with rPackages; [
      #rstudio 
      shiny hexbin
      R6 sf tm ape sp
      magrittr pander
      markdown rsconnect packrat
      tximport tximeta
      factoextra 
      Seurat plotly aricode
      clValid infotheo clue 
      dbscan
      fpc concaveman

      ggplot2 biomaRt 
      ggwordcloud ggforce ggdendro
      ggbeeswarm ggrepel ggridges
      ggalluvial gtable ggraph Cairo
      ggthemes ggrastr ggheatmap

      edgebundle svglite

      biomaRt BiocManager clusterProfiler
      NOISeq enrichR edgeR
      Hmisc umap pheatmap uwot
      dendextend ellipse  rrvgo
      pcaMethods viridis pathview

      tidyverse tidygraph tidytext multidplyr

      pbapply
      treemapify patchwork 
      igraph concaveman gridExtra 
      broom FNN mgsub

      reticulate devtools
      V8 coda rstan

      parallelly

      pmt hrmR
      keras
      hash
    ];
  };
  #
  mySmallPythonBundle = python39.withPackages (ps : with ps;[ numpy pandas scipy statsmodels ]);

in mkShell { buildInputs = [ # HERE WE ADD IN ANY LIBRARIES WE THINK WE MIGHT NEED
   git glibcLocales freetype.dev harfbuzz.dev fribidi openssl which openssh curl wget 
   myRBundle 
   mySmallPythonBundle
]; 
  shellHook = ''
    mkdir -p "$(pwd)/_libs"              # BUILD A LIBRARY THAT R WILL FIND IN THE CURRENT DIRECTORY
    export R_LIBS_USER="$(pwd)/_libs"
  '';
}
