{ lib, ... }:
{
  hosts.home-server = {
    nixos =
      { config, pkgs, ... }:
      {
        sops = {
          secrets.cloudflared = { };
          templates.cloudflared-secret.content = config.sops.placeholder.cloudflared;
        };

        systemd.services = {
          cloudflared = {
            description = "Cloudflare Tunnel";
            after = [
              "network-online.target"
              "sops-install-secrets.service"
              "tailscale-online.target"
            ];
            wants = [
              "network-online.target"
              "sops-install-secrets.service"
              "tailscale-online.target"
            ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${lib.getExe pkgs.cloudflared} tunnel --no-autoupdate run --token-file=${config.sops.templates.cloudflared-secret.path}";
              Restart = "on-failure";
            };
          };
        };
      };
  };
}
