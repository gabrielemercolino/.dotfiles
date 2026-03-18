{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeModules.stylix =
    {
      config,
      pkgs,
      theme,
      ...
    }:
    let
      cfg = config.gab.stylix;

      themePath = self.outPath + "/themes/${theme}.nix";
      loadedTheme = import themePath { inherit config lib pkgs; };

      polarity = loadedTheme.polarity;
      background = loadedTheme.background;
      palette = loadedTheme.palette;
      fonts = loadedTheme.fonts or { };
      opacity = loadedTheme.opacity or 1.0;
    in
    {
      imports = [ inputs.stylix.homeModules.default ];

      options.gab.stylix = {
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

          base16Scheme = palette;
          image = background;
          polarity = polarity;

          fonts = fonts // cfg.fonts;
          opacity.terminal = opacity;

          targets = {
            mangohud.enable = false;
            vscode.enable = false;
            rofi.enable = false;
            zen-browser.enable = false;
          };
        };
      };
    };
}
