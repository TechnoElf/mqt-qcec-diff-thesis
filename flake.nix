{
  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-24.05;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [
          typst
        ];
      };

      packages.mqt-qcec-diff-thesis = pkgs.stdenv.mkDerivation rec {
        name = "mqt-qcec-diff-thesis";
        src = ./.;

        buildInputs = with pkgs; [
          typst
        ];

        buildPhase = ''
          typst compile --font-path template/resources/ main.typ
        '';

        installPhase = ''
          mkdir -p $out
          cp main.pdf $out/${name}.pdf
        '';
      };

      packages.default = self.packages.${system}.mqt-qcec-diff-thesis;
    }
  );
}
