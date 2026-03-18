{ config, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
in
{
  hosts.mini-pc = {
    system = "x86-64_linux";

    keyboard = {
      layout = "it";
    };

    user = {
      name = "gabriele";
    };

    theme = "roathe-dark";

    nixos = {
      imports = with nixos; [
        ./_hardware-configuration.nix
        stylix
      ];
    };

    home = {
      imports = with homeManager; [ stylix ];
    };
  };
}
