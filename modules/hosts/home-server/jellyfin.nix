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
        systemd.tmpfiles.rules = [ "d /tank/jellyfin 0755 ${user.name} users -" ];

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
        };
      };
  };
}
