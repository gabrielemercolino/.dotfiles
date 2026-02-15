{
  config,
  inputs,
  ...
}: let
  cfg = config.gab.style;
  theme = cfg._theme;
  background = theme.background or ./wallpaper.png;
  fonts = theme.fonts or {};
in {
  imports = [inputs.stylix.nixosModules.default];

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
  };
}
