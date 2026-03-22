{ config, lib, ... }:
{
  flake.modules.homeManager = {
    editors.imports = [ config.flake.modules.homeManager.libresprite ];

    libresprite =
      { config, pkgs, ... }:
      let
        cfg = config.gab.editors.libresprite;
      in
      {
        options.gab.editors.libresprite = {
          enable = lib.mkEnableOption "libresprite";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.libresprite ];
        };
      };
  };
}
