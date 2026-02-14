{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.gimp;
in {
  options.gab.apps.gimp = {
    enable = lib.mkEnableOption "gimp";
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.gimp];
  };
}
