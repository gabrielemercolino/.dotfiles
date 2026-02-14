{
  config,
  pkgs,
  ...
}: let
  theme = config.gab.style._theme;
  extras = theme.extras or {};
in {
  home.pointerCursor = {
    enable = true;
    size = extras.cursor.size or 32;
    name = extras.cursor.name or "Vanilla-DMZ";
    package = extras.cursor.package or pkgs.vanilla-dmz;
    hyprcursor.enable = config.stylix.targets.hyprland.enable;
  };
}
