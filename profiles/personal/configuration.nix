{ config, pkgs, ... }:

{
  imports = [
    ../work/configuration.nix
    ../../system/apps/steam.nix
  ];
}