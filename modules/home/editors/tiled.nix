{ self, lib, ... }:
{
  flake.modules.homeManager = {
    editors.imports = [ self.modules.homeManager.tiled ];

    tiled =
      { config, pkgs, ... }:
      let
        cfg = config.gab.editors.tiled;
      in
      {
        options.gab.editors.tiled = {
          enable = lib.mkEnableOption "tiled";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.tiled ];
        };
      };
  };
}
