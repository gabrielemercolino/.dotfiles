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
            settings = {
              theme = "cc-dark";
              packages = [ "npm:@gotgenes/pi-permission-system" ];
            };
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
                "rm -rf *" = "deny";
                "sudo *" = "ask";
              };
              external_directory = "ask";
            };
          };
        };
      };
  };
}
