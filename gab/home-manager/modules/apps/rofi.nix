{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.rofi;
in {
  options.gab.apps.rofi = {
    enable = lib.mkEnableOption "rofi";
  };

  config = {
    programs.rofi = {
      inherit (cfg) enable;
      package = pkgs.rofi;
      extraConfig = {
        modi = "drun";
        show-icons = true;
        icon-theme = "WhiteSur";
        display-drun = "run";
        drun-display-format = "{name}";
      };
    };
  };
}
