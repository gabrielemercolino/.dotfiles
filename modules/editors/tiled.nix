{
  self,
  lib,
  ...
}: {
  flake.homeModules.tiled = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.tiled;
  in {
    options.gab.apps.tiled = {
      enable = lib.mkEnableOption "tiled";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.tiled];
    };
  };

  flake.homeModules.editors = _: {imports = [self.homeModules.tiled];};
}
