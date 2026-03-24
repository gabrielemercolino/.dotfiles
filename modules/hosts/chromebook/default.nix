{ self, inputs, ... }:
let
  inherit (self.modules) nixos homeManager;
in
{
  hosts.chromebook = {
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
      {
        pkgs,
        user,
        ...
      }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          stylix
          gaming
          wm
          login
          cli
          apps

          inputs.sops-nix.nixosModules.sops
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;
        services.upower.enable = true;

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
          };

          wm = {
            hyprland.enable = true;
          };

          login.sddm.enable = true;
        };

        services = {
          xserver.excludePackages = [ pkgs.xterm ];

          logind.settings.Login = {
            HandlePowerKey = "ignore"; # don’t shutdown when power button is short-pressed
          };
        };
      };

    home =
      {
        lib,
        pkgs,
        user,
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

          inputs.sops-nix.homeManagerModules.sops
        ];

        home.packages = [ self.packages.${pkgs.stdenv.buildPlatform.system}.gab ];

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
          };

          browsers = {
            zen.enable = true;
          };

          socials = {
            telegram.enable = true;
            discord.enable = true;
          };

          cli = {
            yazi.enable = true;
          };

          music = {
            mpd.enable = true;
            ncmpcpp.enable = true;
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
                "eDP-1, 1920x1080@60, auto, 1"
                "DP-2, 1920x1080@60, auto, 1, mirror, eDP-1"
              ];
            };
          };
        };
      };
  };
}
