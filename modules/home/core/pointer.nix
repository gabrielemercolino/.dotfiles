{ self, lib, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.pointer ];

    pointer =
      {
        config,
        pkgs,
        loadTheme,
        ...
      }:
      let
        theme = loadTheme { inherit config lib pkgs; };
        home = theme.home or { };
      in
      {
        home.pointerCursor = {
          enable = true;
          size = home.pointerCursor.size or 32;
          name = home.pointerCursor.name or "Vanilla-DMZ";
          package = home.pointerCursor.package or pkgs.vanilla-dmz;
          hyprcursor.enable = true;
        };
      };
  };
}
