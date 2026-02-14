{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.ghostty;
in {
  options.gab.apps.ghostty = {
    enable = lib.mkEnableOption "ghostty";
  };

  config = {
    programs.ghostty = {
      inherit (cfg) enable;
    };
  };
}
