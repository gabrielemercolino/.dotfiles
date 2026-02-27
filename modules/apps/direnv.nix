{lib, ...}: {
  flake.nixosModules.apps = {
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
}
