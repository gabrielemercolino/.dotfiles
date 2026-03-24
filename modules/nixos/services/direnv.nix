{ self, lib, ... }:
{
  flake.modules.nixos = {
    services.imports = [ self.modules.nixos.direnv ];

    direnv =
      { config, pkgs, ... }:
      let
        cfg = config.gab.services.direnv;
      in
      {
        options.gab.services.direnv = {
          enable = lib.mkEnableOption "direnv";
        };

        config = lib.mkIf cfg.enable {
          programs.direnv.enable = true;
          programs.direnv.nix-direnv.enable = true;
        };
      };
  };
}
