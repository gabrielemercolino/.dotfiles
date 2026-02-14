{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    bashmount.enable = lib.mkEnableOption "bashmount (with udisk2)";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.bashmount.enable [pkgs.bashmount];

    # needed for bashmount
    services.udisks2.enable = cfg.bashmount.enable;
  };
}
