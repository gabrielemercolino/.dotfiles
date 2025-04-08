{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.gab.style;
in {
  imports = [inputs.stylix.homeManagerModules.stylix];

  options.gab.style = {
    background = lib.mkOption {
      default = ./wallpaper.png;
      type = lib.types.path;
      description = "The image to use for background";
    };

    theme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.enum [
        "catppuccin-mocha"
        "uwunicorn"
      ];
      description = "The theme to use";
    };
  };

  # fix: even if target is forced to false I need to re-add this otherwise it won't work
  options.wayland.windowManager.hyprland.settings = {
    decoration = lib.mkOption {default = {};};
    general = lib.mkOption {default = {};};
    group = lib.mkOption {default = {};};
    misc = lib.mkOption {default = {};};
  };

  config = {
    stylix = {
      enable = true;
      autoEnable = true;

      base16Scheme = ../../../themes/${cfg.theme}.yaml;
      image = cfg.background;
      targets = {
        mangohud.enable = false;
        hyprland.enable = lib.mkForce false; # hyprland-nix is not compatible
        vscode.enable = false;
      };
    };

    programs.rofi.theme = lib.mkForce (import ./rofi-theme.nix {inherit config;});
    programs.swaylock.settings = {
      effect-blur = "7x5";
      effect-vignette = "0.7:0.7";
      indicator = true;
      clock = true;
    };
  };
}
