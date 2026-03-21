{
  self,
  inputs,
  config,
  ...
}:
let
  inherit (config.flake.modules) nixos homeManager;
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

          inputs.sops-nix.nixosModules.sops
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
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

          gaming = {
            steam.enable = true;
          };

          wm = {
            hyprland.enable = true;
          };

          login.sddm.enable = true;
        };

        # TODO: consider putting this in the base config
        services.xserver.excludePackages = [ pkgs.xterm ];
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

          inputs.sops-nix.homeManagerModules.sops
        ];

        home.packages = [ config.flake.packages.${pkgs.stdenv.buildPlatform.system}.gab ];

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

          gaming = {
            mangohud.enable = true;
          };

          cli = {
            opencode.enable = true;
            yazi.enable = true;
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
                "HDMI-A-1, 1920x1080@100, auto, 1"
                "DP-1, 1920x1080@100, auto, 1"
              ];
            };
          };
        };
      };
  };
}
