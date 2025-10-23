{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.style;
  theme = import ../../../themes/${config.gab.style.theme}.nix {inherit pkgs;};
  background = theme.background or ./wallpaper.png;
  fonts = theme.fonts or {};
in {
  imports = [inputs.stylix.homeModules.stylix];

  options.gab.style = {
    theme = lib.mkOption {
      default = "catppuccin-mocha";
      type = lib.types.enum (
        builtins.readDir ../../../themes
        |> builtins.attrNames
        |> builtins.filter (name: lib.strings.hasSuffix ".nix" name)
        |> map (lib.removeSuffix ".nix")
      );
      description = "The theme to use";
    };

    fonts.sizes = {
      applications = lib.mkOption {
        description = "The font size used for applications";
        default = 12;
      };
      desktop = lib.mkOption {
        description = "The font size used for window titles, status bars, and other general elements of the desktop";
        default = 10;
      };
      popups = lib.mkOption {
        description = "The font size used for notifications, popups, and other overlay elements of the desktop";
        default = 10;
      };
      terminal = lib.mkOption {
        description = "The font size used for terminals and text editors";
        default = 12;
      };
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
      inherit (theme) polarity;

      fonts =
        fonts
        // {
          sizes = {
            inherit (cfg.fonts.sizes) applications;
            inherit (cfg.fonts.sizes) desktop;
            inherit (cfg.fonts.sizes) popups;
            inherit (cfg.fonts.sizes) terminal;
          };
        };

      base16Scheme = theme.palette;
      image = background;
      targets = {
        mangohud.enable = false;
        hyprland.enable = lib.mkForce false; # hyprland-nix is not compatible
        vscode.enable = false;
      };
    };

    programs = {
      rofi.theme = lib.mkForce (import ./rofi-theme.nix {inherit config;});
      swaylock.settings = {
        effect-blur = "7x5";
        effect-vignette = "0.7:0.7";
        indicator = true;
        clock = true;
      };
      btop.settings = {
        color_theme = "TTY";
        force_tty = true;
      };
    };
  };
}
