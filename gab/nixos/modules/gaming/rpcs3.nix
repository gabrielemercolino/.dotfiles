{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    rpcs3.enable = lib.mkEnableOption "rpcs3";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.rpcs3.enable [pkgs.rpcs3];
  };
}
