{
  self,
  lib,
  ...
}: {
  flake.homeModules.obsidian = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.obsidian;
  in {
    options.gab.apps.obsidian = {
      enable = lib.mkEnableOption "obsidian";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.obsidian];
    };
  };

  flake.homeModules.editors = _: {imports = [self.homeModules.obsidian];};
}
