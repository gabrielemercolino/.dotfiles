{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.swaylock;
in {
  options.gab.apps.swaylock = {
    enable = lib.mkEnableOption "swaylock";
  };

  config = {
    programs.swaylock = {
      inherit (cfg) enable;
      package = pkgs.swaylock-effects;
    };
  };
}
