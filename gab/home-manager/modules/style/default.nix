{
  config,
  inputs,
  ...
}: let
  cfg = config.gab.style;
  theme = cfg._theme;
  background = theme.background or ./wallpaper.png;
  fonts = theme.fonts or {};
  opacity = theme.opacity or 1.0;
in {
  imports = [inputs.stylix.homeModules.stylix];

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
  };
}
