{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            extraPackages = [ pkgs.nodejs ];
            settings.packages = [ "npm:@gotgenes/pi-permission-system" ];
          };

          xdg.configFile."pi/agent/extensions/pi-permission-system/config.json".text = builtins.toJSON {
            permission = {
              "*" = "allow";
              path = {
                "*" = "allow";
                "*.env" = "deny";
                "*.env.*" = "deny";
                "*.env.example" = "allow";
              };
              bash = {
                "*" = "ask";

                # read-only core
                "cat *" = "allow";
                "head *" = "allow";
                "tail *" = "allow";
                "wc *" = "allow";
                "grep *" = "allow";
                "egrep *" = "allow";
                "fgrep *" = "allow";
                "rg *" = "allow";
                "ag *" = "allow";
                "diff *" = "allow";
                "ls *" = "allow";
                "stat *" = "allow";
                "pwd *" = "allow";
                "basename *" = "allow";
                "dirname *" = "allow";
                "realpath *" = "allow";
                "readlink *" = "allow";
                "du *" = "allow";
                "df *" = "allow";
                "which *" = "allow";
                "type *" = "allow";
                "command -v *" = "allow";
                "echo *" = "allow";
                "printf *" = "allow";
                "test *" = "allow";
                "true *" = "allow";
                "false *" = "allow";
                "uname *" = "allow";
                "hostname *" = "allow";
                "id *" = "allow";
                "whoami *" = "allow";
                "printenv *" = "allow";
                "date *" = "allow";
                "uptime *" = "allow";
                "free *" = "allow";
                "ps *" = "allow";
                "pgrep *" = "allow";

                # shell state / navigation
                "cd *" = "allow";
                "export *" = "allow";
                "unset *" = "allow";

                # allow guarded readers, the write forms are denied below
                "find *" = "allow";
                "fd *" = "allow";
                "sed *" = "allow";
                "sort *" = "allow";
                "journalctl *" = "allow";

                "systemctl status *" = "allow";

                # hard denies
                "rm -rf *" = "deny";
                "find * -delete*" = "deny";
                "find * -fprint*" = "deny";
                "find * -fls*" = "deny";
                "sed -i*" = "deny";
                "sort -o *" = "deny";
                "sort --output *" = "deny";
                "journalctl --vacuum*" = "deny";
                "sudo *" = "ask";
              };
              external_directory = "ask";
            };
          };
        };
      };
  };
}
