{ config, lib, ... }:
{
  flake.modules.homeManager = {
    editors.imports = [ config.flake.modules.homeManager.obsidian ];

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
