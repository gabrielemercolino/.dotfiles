{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.kitty;
in {
  options.gab.apps.kitty = {
    enable = lib.mkEnableOption "kitty";
  };

  config = {
    programs.kitty = {
      inherit (cfg) enable;
      settings = {
        confirm_os_window_close = 0;
        cursor_trail = 10;
      };
    };
  };
}
