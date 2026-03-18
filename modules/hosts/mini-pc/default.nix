{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  hosts.mini-pc = {
    system = "x86_64-linux";

    keyboard = {
      layout = "it";
    };

    user = {
      name = "gabriele";
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
        ];

        boot.kernelPackages = pkgs.linuxPackages_latest;
        hardware.graphics.extraPackages = [ pkgs.libva ];
        nixpkgs.config.rocmSupport = true;

        gab = {
          gaming = {
            steam.enable = true;
          };

          wm = {
            hyprland.enable = true;
          };
        };

        # TODO: consider putting this in the base config
        services.xserver.excludePackages = [ pkgs.xterm ];
      };

    home = {
      imports = with homeManager; [
        stylix
        editors
        browsers
        wm
      ];

      gab = {
        editors = {
          helix.enable = true;
        };

        browsers = {
          zen.enable = true;
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
