{ self, inputs, ... }:
let
  inherit (self.modules) nixos homeManager;
in
{
  hosts.mini-pc = {
    system = "x86_64-linux";

    audio = "pipewire";

    localization = {
      keyboard.layout = "it";
      locale = "it_IT.UTF-8";
      time.zone = "Europe/Rome";
    };

    user = {
      name = "gabriele";
      email = "gmercolino2003@gmail.com";
    };

    theme = "roathe-dark";

    nixos =
      { pkgs, user, ... }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          stylix
          gaming
          wm
          login
          cli
          apps
          services

          inputs.sops-nix.nixosModules.sops
        ];

        nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];

        nix.settings = rec {
          substituters = [ "https://attic.xuyh0120.win/lantian" ];
          trusted-substituters = substituters;
          trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
        };

        # boot.kernelPackages = pkgs.linuxPackages_latest;
        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
        hardware.graphics.extraPackages = [ pkgs.libva ];
        nixpkgs.config.rocmSupport = true;

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;

        sops = {
          defaultSopsFile = self.outPath + "/secrets/secrets.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";

          secrets = { };
        };

        gab = {
          cli = {
            bashmount.enable = true;
          };

          apps = {
            corectrl.enable = true;
            lact.enable = true;
          };

          gaming = {
            steam.enable = true;
            gamemode.enable = true;
            gamescope.enable = true;
            lsfg.enable = true;
          };

          wm = {
            hyprland.enable = true;
          };

          services = {
            ssh.enable = true;
            direnv.enable = true;
            docker.enable = true;
          };

          login.sddm.enable = true;
        };

        services.xserver.excludePackages = [ pkgs.xterm ];
      };

    home =
      {
        lib,
        pkgs,
        user,
        host,
        ...
      }:
      {
        imports = with homeManager; [
          stylix
          editors
          browsers
          wm
          gaming
          cli
          shell
          socials
          music
          services

          inputs.sops-nix.homeManagerModules.sops
        ];

        home.packages = [ self.packages.${host.system}.gab ];

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

        sops = {
          defaultSopsFile = self.outPath + "/secrets/secrets.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";

          secrets = {
            "ssh/priv" = {
              path = "/home/${user.name}/.ssh/id_ed25519";
            };
            "ssh/pub" = {
              path = "/home/${user.name}/.ssh/id_ed25519.pub";
            };
          };
        };

        gab = {
          editors = {
            helix.enable = true;
            gimp.enable = true;
            libresprite.enable = true;
            tiled.enable = true;
            obsidian.enable = true;
          };

          browsers = {
            zen.enable = true;
          };

          gaming = {
            mangohud.enable = true;
          };

          socials = {
            telegram.enable = true;
            discord.enable = true;
          };

          cli = {
            opencode.enable = true;
            yazi.enable = true;
          };

          music = {
            mpd.enable = true;
            ncmpcpp.enable = true;
          };

          services = {
            resilio.enable = true;
          };

          shell = {
            zsh.enable = true;

            aliases = {
              ls = "${lib.getExe pkgs.eza} --icons";
              ll = "${lib.getExe pkgs.eza} -l --icons";
              la = "${lib.getExe pkgs.eza} -la --icons";

              cd = "z"; # from zoxide
            };
          };

          wm = {
            hyprland = {
              enable = true;
              monitors = [
                {
                  output = "HDMI-A-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
                {
                  output = "DP-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
              ];
            };
          };
        };
      };
  };
}
