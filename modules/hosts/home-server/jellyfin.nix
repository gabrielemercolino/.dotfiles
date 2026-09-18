{ lib, ... }:
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
        systemd.tmpfiles.rules = [ "d /tank/jellyfin 0755 ${user.name} users -" ];

        sops = {
          secrets = {
            "cloudflared/jellyfin" = { };
          };
          templates = {
            cloudflared-jellyfin-secret.content = config.sops.placeholder."cloudflared/jellyfin";
          };
        };

        services = {
          jellyfin = {
            enable = true;
            dataDir = "/tank/jellyfin";
            user = user.name;
            openFirewall = true;
          };
        };

        systemd.services = {
          jellyfin = {
            after = [ "zfs-mount.service" ];
            requires = [ "zfs-mount.service" ];
          };

          cloudflared-jellyfin = {
            description = "Cloudflare Tunnel";
            after = [
              "network-online.target"
              "jellyfin.service"
            ];
            wants = [ "network-online.target" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              ExecStart = "${lib.getExe pkgs.cloudflared} tunnel --no-autoupdate run --token-file=${
                config.sops.templates."cloudflared-jellyfin-secret".path
              }";
              Restart = "on-failure";
            };
          };
        };
      };
  };
}
