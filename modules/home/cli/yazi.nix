{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.yazi ];

    yazi =
      { config, ... }:
      let
        cfg = config.gab.cli.yazi;
      in
      {
        options.gab.cli.yazi = {
          enable = lib.mkEnableOption "yazi";
        };

        config = lib.mkIf cfg.enable {
          programs.yazi = {
            enable = true;
            enableBashIntegration = true;
            enableZshIntegration = true;
            enableFishIntegration = true;

            settings = {
              mgr = {
                sort_by = "alphabetical";
                sort_sensitive = false;
                sord_dir_first = true;
                show_symlink = true;
                show_hidden = true;
              };

              opener = {
                xdg = [
                  {
                    run = "xdg-open %s";
                    block = true;
                  }
                ];
              };
            };
          };
        };
      };
  };
}
