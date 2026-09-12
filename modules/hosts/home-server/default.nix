{ self, lib, ... }:
let
  inherit (self.modules) nixos homeManager;
  inherit (lib) getExe;
in
{
  hosts.home-server = {
    system = "x86_64-linux";

    localization = {
      keyboard.layout = "it";
      locale = "it_IT.UTF-8";
      time.zone = "Europe/Rome";
    };

    user = {
      name = "gabriele";
      email = "ciruzzo032@noreply.codeberg.org";
    };

    nixos =
      {
        config,
        pkgs,
        user,
        ...
      }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          style
          cli
          services
        ];

        # ZFS pool config
        boot.supportedFilesystems.zfs = true;
        boot.zfs.package = config.boot.kernelPackages.zfs_cachyos;
        boot.zfs.extraPools = [ "tank" ];
        networking.hostId = "23b06696";

        # has specific optimisations for this pc
        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
        hardware.graphics.extraPackages = [ pkgs.libva ];

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;

        gab = {
          cli = {
            bashmount.enable = true;
          };

          services = {
            ssh.enable = true;
            direnv.enable = true;
            docker.enable = true;
          };
        };

        services = {
          tailscale.enable = true;

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

    home =
      {
        pkgs,
        user,
        host,
        ...
      }:
      {
        imports = with homeManager; [
          style
          cli
          editors
          shell
          services
        ];

        programs.git = {
          enable = true;
          settings.user = {
            inherit (user) name email;
          };
        };

        programs.jujutsu = {
          enable = true;
          settings.user = {
            inherit (user) name email;
          };
        };

        programs.ghostty.enable = true;

        sops.secrets = {
          "ssh/priv".path = "/home/${user.name}/.ssh/id_ed25519";
          "ssh/pub".path = "/home/${user.name}/.ssh/id_ed25519.pub";
        };

        gab = {
          editors.helix.enable = true;

          cli = {
            yazi.enable = true;
            pi.enable = true;
          };

          services = {
            resilio.enable = true;
          };

          shell = {
            zsh.enable = true;

            aliases = {
              ls = "${getExe pkgs.eza} --icons";
              ll = "${getExe pkgs.eza} -l --icons";
              la = "${getExe pkgs.eza} -la --icons";

              cd = "z"; # from zoxide
            };
          };

        };
      };
  };
}
