{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types) listOf package;
in
{
  perSystem = { config, pkgs, ... }: {
    options.devshell.packages = mkOption {
      type = listOf package;
      default = [ ];
    };
    config.devShells.default = pkgs.mkShellNoCC {
      packages = config.devshell.packages;
    };
  };
}
