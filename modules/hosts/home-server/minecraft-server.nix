{ inputs, ... }:
{
  hosts.home-server = {
    nixos =
      {
        config,
        host,
        lib,
        pkgs,
        self,
        user,
        ...
      }:
      let
        rconAddress = config.services.pumpkin.settings.networking.rcon.address;
        rconHost = lib.head (lib.splitString ":" rconAddress);
        rconPort = lib.last (lib.splitString ":" rconAddress);

        # pumpkin only ever reads <dataDir>/data/*.json; services.pumpkin's own
        # whitelist.entries option writes <dataDir>/whitelist.json, which nothing
        # reads, so the whitelist would stay empty and everyone gets kicked.
        whitelist = [
          {
            name = "Sefiul";
            uuid = "c525f516-0bb1-4722-8a86-fc0f7b529dae";
          }
          {
            name = "Nyramu";
            uuid = "af3185c2-9e95-4af8-9dff-449cd683edfb";
          }
          {
            name = "supergman00";
            uuid = "bcb2a8e2-33e0-4cfc-b2c1-2491120badf8";
          }
        ];
        whitelistFile = (pkgs.formats.json { }).generate "whitelist.json" whitelist;
      in
      {
        imports = [
          inputs.playit-nixos-module.nixosModules.default
        ];

        sops.secrets = {
          "minecraft/playit/secret".path = "/var/lib/minecraft/playit.secret";
          # left on the default path (/run/secrets/...) so the rcon cli can read it
          "minecraft/rcon/password" = {
            owner = user.name;
            mode = "0400";
          };
        };

        services = {
          pumpkin = {
            enable = true;
            openFirewall = true;
            package = self.packages.${host.system}.pumpkin;

            settings = {
              seed = "4";
              default_gamemode = "Creative";
              white_list = true;
              enforce_whitelist = true;

              networking = {
                java = {
                  address = "0.0.0.0:25565";
                  motd = "bismillah wallahi";
                  view_distance = 64; # max
                  simulation_distance = 10;
                  max_players = 20;
                };

                rcon = {
                  enabled = true;
                  address = "127.0.0.1:25575";
                  passwordFile = config.sops.secrets."minecraft/rcon/password".path;
                };
              };
            };
          };

          playit = {
            enable = true;
            secretPath = config.sops.secrets."minecraft/playit/secret".path;
          };
        };

        systemd.services.pumpkin.preStart = lib.mkAfter ''
          install -Dm600 ${whitelistFile} data/whitelist.json
        '';

        # custom cli for easy command access
        environment.systemPackages = [
          (pkgs.writeShellApplication {
            name = "minchiaraft";
            runtimeInputs = [ pkgs.mcrcon ];
            text = ''
              secret=${config.sops.secrets."minecraft/rcon/password".path}

              if [ ! -r "$secret" ]; then
                echo "minchiaraft: cannot read $secret" >&2
                exit 1
              fi

              password=$(< "$secret")

              usage() {
                echo "usage: minchiaraft                # interactive console" >&2
                echo "       minchiaraft send \"<command>\"" >&2
              }

              if [ "$#" -eq 0 ]; then
                exec mcrcon -H ${rconHost} -P ${rconPort} -p "$password"
              fi

              if [ "$1" != send ]; then
                usage
                exit 2
              fi
              shift

              if [ "$#" -eq 0 ]; then
                usage
                exit 2
              fi

              exec mcrcon -H ${rconHost} -P ${rconPort} -p "$password" -c "$*"
            '';
          })
        ];
      };
  };
}
