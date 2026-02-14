{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.gaming;
in {
  options.gab.gaming = {
    suyu.enable = lib.mkEnableOption "suyu";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.suyu.enable [(pkgs.callPackage ./_custom-derivations/suyu.nix {})];
  };
}
