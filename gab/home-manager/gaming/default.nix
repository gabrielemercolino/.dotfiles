{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.gaming;
in {
  imports = [
    ./mangohud.nix
  ];

  options.gab.gaming = {
    geforce.enable = lib.mkEnableOption "geforce-now";
  };

  config = {
    home.packages = lib.optionals cfg.geforce.enable [pkgs.gfn-electron];
  };
}
