{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.idea-community;
in {
  options.gab.apps.idea-community = {
    enable = lib.mkEnableOption "idea community edition";
  };

  config = {
    home.packages = lib.optionals cfg.enable [(pkgs.callPackage ./_package.nix {})];
  };
}
