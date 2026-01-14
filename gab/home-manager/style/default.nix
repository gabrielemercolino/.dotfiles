{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.style;
  theme = import ../../../themes/${config.gab.style.theme}.nix {inherit config pkgs lib;};
  background = theme.background or ./wallpaper.png;
  fonts = theme.fonts or {};
  opacity = theme.opacity or 1.0;
  extras = theme.extras or {};
in {
  imports = [inputs.stylix.homeModules.stylix ./hyprnix.nix];

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

      opacity.terminal = opacity;

      base16Scheme = theme.palette;
      image = background;
      targets = {
        mangohud.enable = false;
        vscode.enable = false;
        rofi.enable = false;
      };
    };

    home.pointerCursor = {
      enable = true;
      size = extras.cursor.size or 32;
      name = extras.cursor.name or "Vanilla-DMZ";
      package = extras.cursor.package or pkgs.vanilla-dmz;
      hyprcursor.enable = config.stylix.targets.hyprland.enable;
    };

    programs = {
      rofi.theme = lib.mkMerge [
        (import ./rofi-theme.nix {inherit config;})
        (extras.rofi or {})
      ];

      swaylock.settings = {
        effect-blur = "7x5";
        effect-vignette = "0.7:0.7";
        indicator = true;
        clock = true;
      };

      btop.settings = {
        color_theme = "TTY";
        theme_background = false;
      };

      alacritty.settings = {
        window = {
          decorations = lib.mkForce "None";
          blur = lib.mkForce false;
        };
      };

      nvf.settings.vim = {
        theme.name = lib.mkForce "base16";
        statusline.lualine.theme = lib.mkForce "base16";
      };

      oh-my-posh.configFile = pkgs.writeText "oh-my-posh.yaml" (builtins.readFile ./oh-my-posh.yaml);

      cava.settings =
        {
          general = {
            sensitivity = 50;
            bar_width = 1;
            bar_spacing = 1;
          };
        }
        // (extras.cava or {});
    };

    wayland.windowManager.hyprland.config = extras.hyprland or {};
  };
}
