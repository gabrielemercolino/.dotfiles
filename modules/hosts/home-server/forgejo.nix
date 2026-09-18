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
        };
      };
  };
}
