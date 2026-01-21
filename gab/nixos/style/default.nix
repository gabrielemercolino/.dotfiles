{
  lib,
  config,
  inputs,
  pkgs,
  userSettings,
  ...
}: let
  cfg = config.gab.style;
  theme = import ../../../themes/${config.gab.style.theme}.nix {inherit config pkgs lib;};
  background = theme.background or ./wallpaper.png;
  profile = theme.profile or null;
  extras = theme.extras or {};
  fonts = theme.fonts or {};

  imgName = img:
    if lib.isDerivation img
    then img.name
    else builtins.baseNameOf img;
in {
  imports = [inputs.stylix.nixosModules.stylix inputs.silentSDDM.nixosModules.default];

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

    programs.silentSDDM = lib.mkMerge [
      {
        enable = true;
        theme = "default";
        backgrounds = {bg = config.stylix.image;};
        # TODO: add default so themes without it won't have the last profile pic set
        profileIcons = lib.mkIf (profile != null) {
          "${userSettings.userName}" = profile;
        };
        settings = {
          "LoginScreen" = {
            blur = 32;
            background = "${imgName config.stylix.image}";
          };
          "LoginScreen.MenuArea.Keyboard" = {
            display = false;
          };
          "LockScreen" = {
            blur = 0;
            background = "${imgName config.stylix.image}";
          };
        };
      }
      (extras.silentSDDM or {})
    ];
  };
}
