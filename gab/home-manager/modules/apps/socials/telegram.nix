{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.telegram;
in {
  options.gab.apps.telegram = {
    enable = lib.mkEnableOption "telegram desktop";
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.telegram-desktop];
  };
}
