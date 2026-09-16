{ ... }:
{
  hosts.home-server = {
    nixos = { user, ... }: {
      systemd.tmpfiles.rules = [ "d /tank/jellyfin 0755 ${user.name} users -" ];

      services = {
        jellyfin = {
          enable = true;
          dataDir = "/tank/jellyfin";
          user = user.name;
          openFirewall = true;
        };
      };
    };
  };
}
