{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.utilities;
in
{
  options.gab.apps.utilities = {
    yazi = lib.mkEnableOption "yazi";
    gimp = lib.mkEnableOption "gimp";
  
    rofi         = lib.mkEnableOption "rofi";
    rofi-wayland = lib.mkEnableOption "rofy for wayland";
  };

  config = {
    assertions = [
      {
        assertion = !( cfg.rofi && cfg.rofi-wayland );
        message   = "Error: cannot install both rofi and rofi-wayland";
      }
    ];

    home.packages = lib.optionals cfg.gimp [ pkgs.gimp ];

    programs.yazi.enable = cfg.yazi;

    programs.rofi = {
      enable = cfg.rofi || cfg.rofi-wayland;
      package = if cfg.rofi-wayland then pkgs.rofi-wayland else pkgs.rofi;
      extraConfig = {
        modi = "drun";
        show-icons = true;
        icon-theme = "WhiteSur";
        display-drun = "";
        display-run = "";
        display-filebrowser = "";
        display-window = "";
        display-emoji = "󰞅";
        display-clipboard = "";
        drun-display-format = "{name}";
        window-format = "{t}";
      };
    };
  };
}
