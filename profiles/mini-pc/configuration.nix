{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix

    # gaming
    ../../system/gaming

    # control
    ../../system/apps/lact.nix

    # development
    ../../system/virtualization/docker.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # for amd gpus
  boot.initrd.kernelModules = [ "amdgpu" ];
  nixpkgs.config.rocmSupport = true;

  gab.gaming.steam = true;
  gab.gaming.gamemode = true;
  gab.gaming.gamescope = true;
}
