{
  self,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.pi ];

    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        options.gab.cli.pi = {
          enable = lib.mkEnableOption "pi coding agent";
        };

        config = lib.mkIf cfg.enable {
          sops.secrets."deepseek/key" = { };

          home.packages = [ pkgs.pi-coding-agent ];

          home.file = {
            ".pi/agent/auth.json".text = ''
              { "deepseek": { "type": "api_key", "key": "!cat ${config.sops.secrets."deepseek/key".path}" } }
            '';

            ".pi/agent/APPEND_SYSTEM.md".source = ./APPEND_SYSTEM.md;

            ".pi/agent/extensions/coder.ts".source = ./coder.ts;
          };
        };
      };
  };
}
