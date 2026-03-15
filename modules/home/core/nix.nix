{ config, ... }:
{
  flake.modules.homeManager = {
    nix = {
      nixpkgs.config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };

    core.imports = [ config.modules.homeManager.nix ];
  };
}
