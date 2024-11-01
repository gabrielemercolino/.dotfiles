{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    yazi.enable = lib.mkEnableOption "yazi";
    gimp.enable = lib.mkEnableOption "gimp";
    obsidian.enable = lib.mkEnableOption "obsidian";

    rofi = {
      enable = lib.mkEnableOption "rofi";
      wayland = lib.mkEnableOption "rofy for wayland";
    };
  };

  config = {
    home.packages =
      lib.optionals cfg.gimp.enable [ pkgs.gimp ]
      ++ lib.optionals cfg.obsidian.enable [ pkgs.obsidian ];

    programs.yazi = {
      enable = cfg.yazi.enable;
      settings = {
        manager = {
          show_hidden = true;
        };
      };
    };

    programs.rofi = {
      enable = cfg.rofi.enable;
      package = if cfg.rofi.wayland then pkgs.rofi-wayland else pkgs.rofi;
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
