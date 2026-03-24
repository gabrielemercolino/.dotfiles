{ self, lib, ... }:
{
  flake.modules.homeManager = {
    socials.imports = [ self.modules.homeManager.telegram ];

    telegram =
      { config, pkgs, ... }:
      let
        cfg = config.gab.socials.telegram;
      in
      {
        options.gab.socials.telegram = {
          enable = lib.mkEnableOption "telegram desktop";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.telegram-desktop ];
        };
      };
  };
}
