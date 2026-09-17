{ ... }:
{
  hosts.home-server = {
    nixos =
      {
        config,
        pkgs,
        user,
        ...
      }:
      {
        sops.secrets = {
          "cloudflared/forgejo" = { };
        };

        services = {
          forgejo = {
            enable = true;
            stateDir = "/tank/forgejo";
            settings = {
              server = {
                DOMAIN = "forgejo.ciruzzo.win";
                ROOT_URL = "https://forgejo.ciruzzo.win/";
                HTTP_ADDR = "127.0.0.1";
              };
            };
          };
        };

        systemd.services = {
          forgejo = {
            after = [ "zfs-mount.service" ];
            requires = [ "zfs-mount.service" ];
          };

          cloudflared-forgejo = {
            description = "Cloudflare Tunnel";
            after = [
              "network-online.target"
              "forgejo.service"
            ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              DynamicUser = true;
              LoadCredential = "token:${config.sops.secrets."cloudflared/forgejo".path}";
              ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file=%d/token";
              Restart = "on-failure";
            };
          };
        };
      };
  };
}
