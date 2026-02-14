{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.yazi;
in {
  options.gab.apps.yazi = {
    enable = lib.mkEnableOption "yazi";
  };

  config = {
    programs.yazi = {
      inherit (cfg) enable;

      settings = {
        mgr = {
          show_hidden = true;
        };

        opener = {
          xdg = [
            {
              run = ''xdg-open "$@"'';
              block = true;
            }
          ];
        };
        open = {
          rules = [
            {
              mime = "text/*";
              use = "xdg";
            }
            {
              mime = "video/*";
              use = "xdg";
            }
            {
              mime = "image/*";
              use = "xdg";
            }
            {
              mime = "application/*";
              use = "xdg";
            }
          ];
        };
      };
    };
  };
}
