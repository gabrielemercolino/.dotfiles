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
      };

      services = {
        vaultwarden = {
          enable = true;
          dbBackend = "sqlite";
          environmentFile = config.sops.secrets."vaultwarden/env".path;
          backupDir = "/tank/vaultwarden/backup";
          config = {
            SIGNUPS_ALLOWED = true;
            DOMAIN = "https://home-server.taild25961.ts.net:8222";
            ROCKET_ADDRESS = "127.0.0.1";
            ROCKET_PORT = 8222;
            DATA_FOLDER = "/tank/vaultwarden/data";
          };
        };
      };

      systemd.services = {
        vaultwarden.serviceConfig.ReadWritePaths = [ "/tank/vaultwarden" ];
        tailscale-serve-vaultwarden = {
          description = "tailscale https serve for Vaultwarden";
          after = [
            "tailscaled.service"
            "vaultwarden.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=8222 http://127.0.0.1:8222";
            ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=8222 off";
          };
        };
      };
    };
  };
}
