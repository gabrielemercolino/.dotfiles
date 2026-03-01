{
  self,
  lib,
  ...
}: {
  flake.homeModules.kitty = {config, ...}: let
    cfg = config.gab.apps.kitty;
  in {
    options.gab.apps.kitty = {
      enable = lib.mkEnableOption "kitty";
    };

    config = lib.mkIf cfg.enable {
      programs.kitty = {
        enable = true;

        settings = {
          confirm_os_window_close = 0;
          cursor_trail = 10;
        };
      };
    };
  };

  flake.homeModules.apps = _: {imports = [self.homeModules.kitty];};
}
