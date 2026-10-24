{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        options.gab.cli.pi.agentmemory = {
          port = lib.mkOption {
            type = lib.types.port;
            default = 8443;
            description = "agentmemory HTTPS port on the Tailscale Serve host.";
          };
        };

        config = lib.mkIf cfg.enable {
          programs.pi-coding-agent = {
            extraPackages = [ pkgs.nodejs ];
            settings.packages = [ "npm:@estebanforge/pi-agentmemory" ];
          };

          sops = {
            secrets = {
              "agentmemory/host" = { };
              "agentmemory/secret" = { };
            };

            templates."agentmemory.env".content = ''
              export AGENTMEMORY_URL="https://${config.sops.placeholder."agentmemory/host"}:${toString cfg.agentmemory.port}"
              export AGENTMEMORY_SECRET="${config.sops.placeholder."agentmemory/secret"}"
              export AGENTMEMORY_REQUIRE_HTTPS="1"
            '';
          };

          gab.cli.pi.envFiles = [ config.sops.templates."agentmemory.env".path ];
        };
      };
  };
}
