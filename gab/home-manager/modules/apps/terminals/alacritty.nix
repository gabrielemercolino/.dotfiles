{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.alacritty;
in {
  options.gab.apps.alacritty = {
    enable = lib.mkEnableOption "alacritty";
  };

  config = {
    programs.alacritty = {
      inherit (cfg) enable;
    };
  };
}
