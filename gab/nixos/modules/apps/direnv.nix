{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    direnv.enable = lib.mkEnableOption "direnv";
  };

  config = {
    programs.direnv.enable = cfg.direnv.enable;
  };
}
