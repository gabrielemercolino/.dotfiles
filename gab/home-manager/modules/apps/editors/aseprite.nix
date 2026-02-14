{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.aseprite;
in {
  options.gab.apps.aseprite = {
    enable = lib.mkEnableOption "aseprite";
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.aseprite];
  };
}
