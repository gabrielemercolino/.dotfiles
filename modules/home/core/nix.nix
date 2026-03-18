{ config, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ config.modules.homeManager.nix ];

    nix = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  };
}
