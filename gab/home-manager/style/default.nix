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
        zen-browser.enable = false;
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

      oh-my-posh.configFile = pkgs.writeText "oh-my-posh.yaml" (builtins.readFile ./oh-my-posh.yaml);

      cava.settings = lib.mkMerge [
        {
          general = {
            sensitivity = 50;
            bar_width = 1;
            bar_spacing = 1;
          };
        }
        (extras.cava or {})
      ];
    };

    wayland.windowManager.hyprland.config = extras.hyprland or {};
  };
}
