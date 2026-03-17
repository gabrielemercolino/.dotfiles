{ config, lib, ... }:
let
  inherit (config.flake.modules) nixos homeManager;
  stateVersion = "26.05";
in
{
  flake.modules = {
    nixos.common-host = {
      imports = with nixos; [
        core
        fonts
      ];

      system.stateVersion = lib.mkDefault stateVersion;
    };

    homeManager.common-host = {
      imports = with homeManager; [ core ];

      home.stateVersion = lib.mkDefault stateVersion;
    };
  };
}
