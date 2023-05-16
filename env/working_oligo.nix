let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz"; 
    sha256 = "11z6ajj108fy2q5g8y4higlcaqncrbjm3dnv17pvif6avagw4mcb";
  };
  pkgs = import nixpkgs {
    config = {};
    overlays = [
      (self: super: {
        # Try and update the version of openblas
        openblas = super.openblas.overrideAttrs (attrs: rec {
          name = pname + "-" + version;
          pname = "openblas";
          version = "0.3.3";
          src = super.fetchFromGitHub {
            owner = "xianyi";
            repo = "OpenBLAS";
            rev = "v" + version;
            sha256 = "ndPJ06D5R+AI51rkQ+8DB+eNbk4h1exiTbWTwLbb8zI=";
          };
        });
        rPackages = super.rPackages.override {
          overrides = {
            oligo = super.rPackages.oligo.overrideDerivation (oldAttrs: {
              PKG_LIBS = "-L${super.blas}/lib -lblas";
              nativeBuildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.nativeBuildInputs);
              buildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.buildInputs);
            });
            affy = super.rPackages.affy.overrideDerivation (oldAttrs: {
              PKG_LIBS = "-L${super.blas}/lib -lblas";
              nativeBuildInputs = super.lib.filter (e: (e) != super.openblas) (oldAttrs.nativeBuildInputs);
            });
          };
        };
      })
    ];
  };
in

with pkgs ;

mkShell {
  buildInputs = let
    R-with-packages = rWrapper.override {
      packages = with rPackages ;
        [
          R rmarkdown affycoretools affy
          pd_hg_u133_plus_2 
          clusterProfiler DOSE
          oligo pd_hta_2_0 glibc blas
        ];
      };
    in
  [
    R-with-packages
  ];
}
