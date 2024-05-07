{
  description = "template dev flake";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            
          ];
          shellHook = "clear && echo \"Welcome!\" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat";
        };
      }
    );
}
