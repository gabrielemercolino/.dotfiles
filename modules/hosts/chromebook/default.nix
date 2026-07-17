{
  self,
  inputs,
  lib,
  ...
}:
let
  inherit (self.modules) nixos homeManager;
  inherit (lib) getExe;
in
{
  hosts.chromebook = {
    system = "x86_64-linux";

    audio = "pipewire";

    performance = "low";

    localization = {
      keyboard.layout = "it";
      locale = "it_IT.UTF-8";
      time.zone = "Europe/Rome";
    };

    user = {
      name = "gabriele";
      email = "ciruzzo032@noreply.codeberg.org";
    };

    theme = "roathe-dark";

    nixos =
      { pkgs, user, ... }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          style
          gaming
          wm
          login
          cli
          apps
          services

          inputs.sops-nix.nixosModules.sops
        ];

        hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;

        services.upower.enable = true;

        sops.secrets = { };

        gab = {
          kernel = {
            scx.enable = true;
          };

          cli = {
            bashmount.enable = true;
          };

          apps = {
            corectrl.enable = true;
          };

          gaming = {
            steam.enable = true;
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

        services = {
          xserver.excludePackages = [ pkgs.xterm ];

          logind.settings.Login = {
            HandlePowerKey = "ignore"; # don’t shutdown when power button is short-pressed
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
          editors
          browsers
          wm
          cli
          shell
          socials
          music
          services

          inputs.sops-nix.homeManagerModules.sops
        ];

        home.packages = with self.packages.${host.system}; [
          gab
          cisco-packet-tracer
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

        sops.secrets = {
          "ssh/priv".path = "/home/${user.name}/.ssh/id_ed25519";
          "ssh/pub".path = "/home/${user.name}/.ssh/id_ed25519.pub";
        };

        gab = {
          editors = {
            helix.enable = true;
            obsidian.enable = true;
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
            pi.enable = true;
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
              ls = "${getExe pkgs.eza} --icons";
              ll = "${getExe pkgs.eza} -l --icons";
              la = "${getExe pkgs.eza} -la --icons";

              cd = "z"; # from zoxide
            };
          };

          wm = {
            hyprland = {
              enable = true;
              monitors = [
                {
                  output = "eDP-1";
                  mode = "1920x1080@60";
                  position = "auto";
                }
                {
                  output = "DP-2";
                  mode = "1920x1080@60";
                  position = "auto";
                  mirror = "eDP-1";
                }
              ];
            };
          };
        };
      };
  };
}
