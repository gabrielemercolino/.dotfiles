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
        systemd.tmpfiles.rules = [ "d /tank/duplicati 0700 ${user.name} duplicati -" ];

        sops = {
          secrets = {
            "duplicati/db/key" = { };
            "duplicati/web/key" = { };
          };
          templates."duplicati.env".content = ''
            SETTINGS_ENCRYPTION_KEY=${config.sops.placeholder."duplicati/db/key"}
            DUPLICATI__WEBSERVICE_PASSWORD=${config.sops.placeholder."duplicati/web/key"}
          '';
        };

        services = {
          duplicati = {
            enable = true;
            interface = "any";
            user = user.name;
            dataDir = "/tank/duplicati";
            parameters = "--webservice-allowedhostnames=*";
          };
        };

        systemd.services = {
          duplicati = {
            unitConfig.RequiresMountsFor = "/tank/duplicati";
            serviceConfig.EnvironmentFile = config.sops.templates."duplicati.env".path;
          };
        };

        networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8200 ];
      };
  };
}
