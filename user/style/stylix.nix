{ config, pkgs, lib, stylix, userSettings, ... }:

let
  themePath = "../../../themes"+("/"+userSettings.theme)+"/styles.yaml";
  themePolarity = lib.removeSuffix "\n" (builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/polarity.txt"));
  backgroundUrl = builtins.readFile (./. + "../../../themes"+("/"+userSettings.theme)+"/bgUrl.txt");
  backgroundSha256 = builtins.readFile (./. + "../../../themes/"+("/"+userSettings.theme)+"/bgSha256.txt");
in
{
  imports = [
    stylix.homeManagerModules.stylix
  ];

  stylix.autoEnable = false;
  stylix.polarity = themePolarity;
  stylix.image = pkgs.fetchurl {
    url = backgroundUrl;
    sha256 = backgroundSha256;
  };
  stylix.base16Scheme = ./. + themePath;

  stylix.fonts = {
    monospace = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    serif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    sansSerif = {
      name = userSettings.font;
      package = userSettings.fontPkg;
    };
    emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-emoji-blob-bin;
    };
    sizes = {
      terminal = 12;
      applications = 10;
      popups = 12;
      desktop = 12;
    };
  };

  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ''+config.stylix.image+''

    wallpaper = eDP-1,''+config.stylix.image+''

    wallpaper = HDMI-A-1,''+config.stylix.image+''

    wallpaper = DP-1,''+config.stylix.image+''
  '';

  stylix.targets.kitty.enable = false;
  stylix.targets.gtk.enable = true;
  stylix.targets.rofi.enable = true;

  gtk.cursorTheme = {
    package = pkgs.quintom-cursor-theme;
    name = if (themePolarity == "light") then "Quintom_Ink" else "Quintom_Snow";
    size = 36;
  };

  home.packages = with pkgs; [
     qt5ct pkgs.libsForQt5.breeze-qt5
  ];
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  programs.zsh.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  programs.bash.sessionVariables = {
    QT_QPA_PLATFORMTHEME="qt5ct";
  };
  qt = {
    enable = true;
    style.package = pkgs.libsForQt5.breeze-qt5;
    style.name = "breeze-dark";
  };
}