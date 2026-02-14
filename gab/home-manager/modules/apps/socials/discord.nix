{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.discord;
in {
  options.gab.apps.discord = {
    enable = lib.mkEnableOption "discord";
  };

  config = {
    home.packages = lib.optionals cfg.enable [(pkgs.discord.override {withEquicord = true;})];
  };
}
