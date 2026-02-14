{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    steam.enable = lib.mkEnableOption "steam";
  };

  config = {
    boot.kernelModules = lib.optionals cfg.steam.enable ["ntsync"];

    programs.steam = {
      enable = cfg.steam.enable;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };
}
