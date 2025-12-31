{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.style;
  theme = import ../../../themes/${config.gab.style.theme}.nix {inherit pkgs;};
  background = theme.background or ./wallpaper.png;
  fonts = theme.fonts or {};
in {
  imports = [inputs.stylix.nixosModules.stylix inputs.silentSDDM.nixosModules.default];

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

      base16Scheme = theme.palette;
      image = background;

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
    };

    programs.silentSDDM = {
      enable = true;
      theme = "default";
      backgrounds = {bg = config.stylix.image;};
      settings = {
        "LoginScreen" = {
          blur = 32;
          background = "${config.stylix.image.name}";
        };
        "LoginScreen.MenuArea.Keyboard" = {
          display = false;
        };
        "LockScreen" = {
          blur = 0;
          background = "${config.stylix.image.name}";
        };
      };
    };
  };
}
