{ ... }:
{
  hosts.home-server = {
    nixos = { config, user, ... }: {
      systemd.tmpfiles.rules = [ "d /tank/media 0755 ${user.name} users -" ];

      services = {
        samba = {
          enable = true;
          openFirewall = true;

          settings = {
            global = {
              "workgroup" = "WORKGROUP";
              "server string" = "HomeServer";
              "netbios name" = "HOMESERVER";
              "security" = "user";
              "map to guest" = "never";
            };
            share = {
              path = "/tank/share";
              browseable = "yes";
              "read only" = "no";
              "valid users" = "gabriele";
              "force user" = "gabriele";
            };
          };
        };

        samba-wsdd = {
          enable = true;
          openFirewall = true;
          discovery = true;
          interface = "wlp6s0";
        };

        avahi = {
          enable = true;
          publish.enable = true;
          publish.userServices = true;
        };
      };
    };
  };
}
