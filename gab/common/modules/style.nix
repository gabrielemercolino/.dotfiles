{
  lib,
  config,
  pkgs,
  ...
}: let
  theme = import ../../../themes/${config.gab.style.theme}.nix {inherit config pkgs lib;};
in {
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

    _theme = lib.mkOption {
      type = lib.types.attrs;
      internal = true;
      default = theme;
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
}
