{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.style;

  sddm-theme = inputs.silentSDDM.packages.${pkgs.system}.default.overrideAttrs (prev: {
    installPhase = ''
      ${prev.installPhase}
      cp ${./wallpaper.png} $out/share/sddm/themes/silent/backgrounds/default.jpg
      cp ${./wallpaper.png} $out/share/sddm/themes/silent/backgrounds/smoky.jpg
    '';
  });
in {
  imports = [inputs.stylix.nixosModules.stylix];

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

      base16Scheme = ../../../themes/${cfg.theme}.yaml;
      image = cfg.background;

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
