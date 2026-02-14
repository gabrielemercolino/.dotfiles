{
  lib,
  config,
  ...
}: let
  theme = config.gab.style._theme;
  extras = theme.extras or {};
in {
  programs.cava.settings = lib.mkMerge [
    {
      general = {
        sensitivity = 50;
        bar_width = 1;
        bar_spacing = 1;
      };
    }
    (extras.cava or {})
  ];
}
