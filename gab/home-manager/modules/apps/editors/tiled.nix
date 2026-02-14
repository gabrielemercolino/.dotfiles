{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.tiled;
in {
  options.gab.apps.tiled = {
    enable = lib.mkEnableOption "tiled";
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.tiled];
  };
}
