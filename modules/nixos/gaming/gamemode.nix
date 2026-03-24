{ self, lib, ... }:
{
  flake.modules.nixos = {
    gaming.imports = [ self.modules.nixos.gamemode ];

    gamemode =
      {
        config,
        pkgs,
        user,
        ...
      }:
      let
        cfg = config.gab.gaming.gamemode;
      in
      {
        options.gab.gaming.gamemode = {
          enable = lib.mkEnableOption "gamemode";
        };

        config = lib.mkIf cfg.enable {
          # needed to make the renice setting work
          users.users.${user.name}.extraGroups = [ "gamemode" ];

          programs.gamemode = {
            enable = true;
            enableRenice = true;
            settings = {
              general = {
                renice = 5;
                igpu_desiredgov = "performance";
              };
            };
          };
        };
      };
  };
}
