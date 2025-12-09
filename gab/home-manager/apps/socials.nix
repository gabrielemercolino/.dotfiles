{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    telegram.enable = lib.mkEnableOption "telegram desktop";
    discord.enable = lib.mkEnableOption "discord";
  };

  config = {
    home.packages =
      lib.optionals cfg.telegram.enable [pkgs.telegram-desktop]
      ++ lib.optionals cfg.discord.enable [
        (pkgs.discord.override {withEquicord = true;})
      ];
  };
}
