{ ... }:
{
  hosts.home-server = {
    nixos = { config, pkgs, ... }: {
      systemd.tmpfiles.rules = [
        "d /tank/vaultwarden 0750 vaultwarden vaultwarden -"
        "d /tank/vaultwarden/data 0750 vaultwarden vaultwarden -"
      ];

      sops.secrets = {
        "vaultwarden/env" = {
          owner = "vaultwarden";
          group = "vaultwarden";
        };
        "cloudflared/vaultwarden" = { };
      };

      services = {
        vaultwarden = {
          enable = true;
          dbBackend = "sqlite";
          environmentFile = config.sops.secrets."vaultwarden/env".path;
          backupDir = "/tank/vaultwarden/backup";
          config = {
            SIGNUPS_ALLOWED = true;
            DOMAIN = "https://vaultwarden.ciruzzo.win";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
            DATA_FOLDER = "/tank/vaultwarden/data";
          };
        };
      };

      systemd.services = {
        vaultwarden = {
          after = [ "zfs-mount.service" ];
          requires = [ "zfs-mount.service" ];
          serviceConfig.ReadWritePaths = [ "/tank/vaultwarden" ];
        };
        cloudflared-vaultwarden = {
          description = "Cloudflare Tunnel";
          after = [
            "network-online.target"
            "vaultwarden.service"
          ];
          wants = [ "network-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            DynamicUser = true;
            LoadCredential = "token:${config.sops.secrets."cloudflared/vaultwarden".path}";
            ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token-file=%d/token";
            Restart = "on-failure";
          };
        };
      };
    };
  };
}
