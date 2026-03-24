{ self, lib, ... }:
{
  flake.modules.homeManager = {
    editors.imports = [ self.modules.homeManager.obsidian ];

    obsidian =
      { config, pkgs, ... }:
      let
        cfg = config.gab.editors.obsidian;
      in
      {
        options.gab.editors.obsidian = {
          enable = lib.mkEnableOption "obsidian";
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.obsidian ];
        };
      };
  };
}
