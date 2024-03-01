{
  description = "template dev flake";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =
        pkgs.mkShell
          {
            nativeBuildInputs = with pkgs; [
              # Add packages here
            ];

            shellHook = "clear && echo \"Welcome!\" | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat && exec zsh";
          };
    };
}