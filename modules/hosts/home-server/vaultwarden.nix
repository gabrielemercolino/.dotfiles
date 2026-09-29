{ ... }:
{
  hosts.home-server = {
    nixos = { config, pkgs, ... }: {
      systemd.tmpfiles.rules = [
        "d /tank/vaultwarden 0750 vaultwarden vaultwarden -"
        "d /tank/vaultwarden/data 0750 vaultwarden vaultwarden -"
      ];

      sops = {
        secrets = {
          "vaultwarden/admin/token" = {
            owner = "vaultwarden";
            group = "vaultwarden";
          };
        };
        templates."vaultwarden.env" = {
          content = "ADMIN_TOKEN=${config.sops.placeholder."vaultwarden/admin/token"}";
          owner = "vaultwarden";
          group = "vaultwarden";
        };
      };

      services = {
        vaultwarden = {
          enable = true;
          dbBackend = "sqlite";
          environmentFile = config.sops.templates."vaultwarden.env".path;
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
      };
    };
  };
}
