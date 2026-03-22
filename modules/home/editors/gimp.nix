{ config, lib, ... }:
{
  flake.modules.homeManager = {
    editors.imports = [ config.flake.modules.homeManager.gimp ];

    gimp =
      { config, pkgs, ... }:
      let
        cfg = config.gab.editors.gimp;
      in
      {
        options.gab.editors.gimp = {
          enable = lib.mkEnableOption "gimp";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.gimp ];
        };
      };
  };
}
