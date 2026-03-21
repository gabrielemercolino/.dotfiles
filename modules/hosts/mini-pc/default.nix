{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  hosts.mini-pc = {
    system = "x86_64-linux";

    audio = "pipewire";

    keyboard = {
      layout = "it";
    };

    user = {
      name = "gabriele";
      email = "gmercolino2003@gmail.com";
    };

    theme = "roathe-dark";

    nixos =
      { pkgs, ... }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          stylix
          gaming
          wm
          login
          cli
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        hardware.graphics.extraPackages = [ pkgs.libva ];
        nixpkgs.config.rocmSupport = true;

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;

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
