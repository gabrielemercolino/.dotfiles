{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    lsfg.enable = lib.mkEnableOption "lsfg-vk[-ui]";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.lsfg.enable [pkgs.lsfg-vk-ui pkgs.lsfg-vk];
  };
}
