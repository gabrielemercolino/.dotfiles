{
  config,
  lib,
  ...
}: let
  theme = config.gab.style._theme;
  extras = theme.extras or {};
in {
  programs.rofi = {
    theme = lib.mkMerge [
      (import ./_theme.nix {inherit config;})
      (extras.rofi or {})
    ];
  };
}
