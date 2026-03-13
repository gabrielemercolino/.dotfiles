{
  self,
  lib,
  ...
}: {
  flake.homeModules.gimp = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.gimp;
  in {
    options.gab.apps.gimp = {
      enable = lib.mkEnableOption "gimp";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.gimp];
    };
  };

  flake.homeModules.editors = _: {imports = [self.homeModules.gimp];};
}
