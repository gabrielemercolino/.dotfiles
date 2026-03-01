{
  self,
  lib,
  ...
}: {
  flake.homeModules.yazi = {config, ...}: let
    cfg = config.gab.apps.yazi;
  in {
    options.gab.apps.yazi = {
      enable = lib.mkEnableOption "yazi";
    };

    config = lib.mkIf cfg.enable {
      programs.yazi = {
        enable = true;

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
  };

  flake.homeModules.apps = _: {imports = [self.homeModules.yazi];};
}
