{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.style;
  theme = import ../../../themes/${config.gab.style.theme}.nix;
  background' = theme.bgLink or null;
  background =
    if background' != null
    then
      pkgs.fetchurl {
        url = theme.bgLink;
        hash = theme.bgHash;
      }
    else ./wallpaper.png;
  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.overrideAttrs (prev: {
    installPhase = ''
      ${prev.installPhase}
      cp ${background} $out/share/sddm/themes/silent/backgrounds/default.jpg
      cp ${background} $out/share/sddm/themes/silent/backgrounds/smoky.jpg
    '';
  });
in {
  imports = [inputs.stylix.nixosModules.stylix];

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
    environment.systemPackages = [sddm-theme];

    stylix = {
      enable = true;
      autoEnable = true;
      inherit (theme) polarity;

      base16Scheme = theme;
      image = background;

      fonts.sizes = {
        inherit (cfg.fonts.sizes) applications;
        inherit (cfg.fonts.sizes) desktop;
        inherit (cfg.fonts.sizes) popups;
        inherit (cfg.fonts.sizes) terminal;
      };
    };

    services.displayManager.sddm = {
      theme = sddm-theme.pname;
      extraPackages = sddm-theme.propagatedBuildInputs;
      settings = {
        # required for styling the virtual keyboard
        General = {
          GreeterEnvironment = "QML2_IMPORT_PATH=${sddm-theme}/share/sddm/themes/${sddm-theme.pname}/components/,QT_IM_MODULE=qtvirtualkeyboard";
          InputMethod = "qtvirtualkeyboard";
        };
      };
    };
  };
}
