{
  config,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    core.imports = [ config.flake.modules.homeManager.pointer ];

    pointer =
      {
        config,
        pkgs,
        loadTheme,
        ...
      }:
      let
        theme = loadTheme { inherit config lib pkgs; };
        extras = theme.extras or { };
      in
      {
        home.pointerCursor = {
          enable = true;
          size = extras.cursor.size or 32;
          name = extras.cursor.name or "Vanilla-DMZ";
          package = extras.cursor.package or pkgs.vanilla-dmz;
          hyprcursor.enable = config.home.pointerCursor.hyprcursor.enable;
        };
      };
  };
}
