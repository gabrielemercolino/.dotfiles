{ self, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.pointer ];

    pointer =
      { config, pkgs, ... }:
      {
        home.pointerCursor = {
          enable = true;
          size = 32;
          name = "Vanilla-DMZ";
          package = pkgs.vanilla-dmz;
          hyprcursor.enable = true;
        };
      };
  };
}
