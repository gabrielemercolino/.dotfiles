{
  lib,
  config,
  inputs,
  userSettings,
  ...
}: let
  cfg = config.gab.style;
  theme = cfg._theme;
  background = theme.background or ./wallpaper.png;
  profile = theme.profile or null;
  extras = theme.extras or {};

  imgName = img:
    if lib.isDerivation img
    then img.name
    else builtins.baseNameOf img;
in {
  imports = [inputs.silentSDDM.nixosModules.default];

  config = {
    programs.silentSDDM = lib.mkMerge [
      {
        enable = true;
        theme = "default";
        backgrounds = {bg = background;};
        # TODO: add default so themes without it won't have the last profile pic set
        profileIcons = lib.mkIf (profile != null) {
          "${userSettings.userName}" = profile;
        };
        settings = {
          "LoginScreen" = {
            blur = 32;
            background = "${imgName background}";
          };
          "LoginScreen.MenuArea.Keyboard" = {
            display = false;
          };
          "LockScreen" = {
            blur = 0;
            background = "${imgName background}";
          };
          "LockScreen.Date" = {
            format = "dd/MM/yyyy";
            locale = "it_IT";
          };
        };
      }
      (extras.silentSDDM or {})
    ];
  };
}
