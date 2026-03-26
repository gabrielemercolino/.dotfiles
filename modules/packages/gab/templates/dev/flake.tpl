{
  description = "Project description";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          treefmt.config = {
            projectRootFile = "flake.nix";
            flakeCheck = true;
            programs.nixfmt.enable = true;
          };

          packages.default = pkgs.hello;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [  ];
            shellHook =
              #sh
              ''
                echo "dev shell activated"
              '';
          };
        };

      flake = { };
    };
}
