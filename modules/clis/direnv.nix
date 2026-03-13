{
  self,
  lib,
  ...
}: {
  flake.nixosModules.direnv = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.apps.direnv;
  in {
    options.gab.apps.direnv = {
      enable = lib.mkEnableOption "direnv";
    };

    config = lib.mkIf cfg.enable {
      programs.direnv.enable = true;
    };
  };

  flake.nixosModules.clis = _: {imports = [self.nixosModules.direnv];};
}
