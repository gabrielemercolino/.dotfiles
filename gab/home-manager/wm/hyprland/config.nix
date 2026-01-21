{
  bar,
  lib,
  pkgs,
  config,
  systemSettings,
}: {
  exec_once = [
    "${lib.getExe bar}"
  ];
  exec = [
    "${lib.getExe pkgs.swaybg} -m fill -i ${config.stylix.image}"
  ];

  workspace = [
    "1, persistent:true"
    "2, persistent:true"
    "3, persistent:true"
  ];

  general = {
    gaps_in = 5;
    gaps_out = 20;
    border_size = 2;
    layout = "dwindle";
    allow_tearing = false;
  };

  decoration = {
    rounding = 10;
    blur = {
      enabled = true;
      size = 3;
      passes = 1;
    };
    shadow = {
      enabled = true;
      range = 4;
      render_power = 3;
    };
  };

  group = {
    auto_group = true;

    groupbar = {
      font_size = 13;
      gradients = false;
      indicator_height = 2;
      rounding = 8;
      rounding_power = 4.0;
      blur = true;
    };
  };

  input = {
    kb_layout = systemSettings.kb.layout;
    kb_variant = systemSettings.kb.variant;
    follow_mouse = 1;
    touchpad.natural_scroll = "no";
  };

  dwindle = {
    pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section
    preserve_split = "yes"; # you probably want this
  };

  master = {
    new_status = "master";
  };

  gesture = [
    "3, swipe, workspace"
  ];

  misc = {
    force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
  };
}
