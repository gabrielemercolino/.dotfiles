{
  self,
  lib,
  ...
}: {
  flake.nixosModules.gamemode = {config, ...}: let
    cfg = config.gab.gaming.gamemode;
  in {
    imports = [self.nixosModules.user];

    options.gab.gaming.gamemode = {
      enable = lib.mkEnableOption "gamemode";
    };

    config = lib.mkIf cfg.enable {
      # needed to make the renice setting work
      users.users.${config.gab.user.name}.extraGroups = ["gamemode"];

      programs.gamemode = {
        enable = true;
        enableRenice = true;

        settings.general = {
          renice = 5;
          igpu_desiredgov = "performance";
        };
      };
    };
  };

  flake.nixosModules.gaming = _: {imports = [self.nixosModules.gamemode];};
}
