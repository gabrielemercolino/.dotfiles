{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.obsidian;
in {
  options.gab.apps.obsidian = {
    enable = lib.mkEnableOption "obsidian";
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.obsidian];
  };
}
