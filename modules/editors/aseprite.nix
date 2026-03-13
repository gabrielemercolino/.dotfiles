{
  self,
  lib,
  ...
}: {
  flake.homeModules.aseprite = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.aseprite;
  in {
    options.gab.apps.aseprite = {
      enable = lib.mkEnableOption "aseprite";
    };

    config = lib.mkIf cfg.enable {
      home.packages = [pkgs.aseprite];
    };
  };

  flake.homeModules.editors = _: {imports = [self.homeModules.aseprite];};
}
