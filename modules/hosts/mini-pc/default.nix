{config, ...}: let
  inherit (config.flake.modules) nixos homeManager;
in {
  hosts.mini-pc = {
    system = "x86-64_linux";

    keyboard = {
      layout = "it";
    };

    user = {
      name = "gabriele";
    };

    theme = "roathe-dark";

    nixos = {pkgs, ...}: {
      imports = with nixos; [
        ./_hardware-configuration.nix
        stylix
        gaming
      ];

      boot.kernelPackages = pkgs.linuxPackages_latest;
      hardware.graphics.extraPackages = [pkgs.libva];
      nixpkgs.config.rocmSupport = true;

      gab = {
        gaming = {
          steam.enable = true;
        };
      };

      # TODO: consider putting this in the base config
      services.xserver.excludePackages = [pkgs.xterm];
    };

    home = {
      imports = with homeManager; [
        stylix
        editors
        browsers
      ];

      gab = {
        editors = {
          helix.enable = true;
        };

        browsers = {
          zen.enable = true;
        };
      };
    };
  };
}
