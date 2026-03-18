{ config, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ config.flake.modules.homeManager.nix ];

    nix = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
