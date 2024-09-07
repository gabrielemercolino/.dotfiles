{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix

    # gaming
    ../../system/gaming/steam.nix
    ../../system/gaming/gamescope.nix
    ../../system/gaming/gamemode.nix

    # control
    ../../system/apps/lact.nix

    # development
    ../../system/virtualization/docker.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # for amd gpus
  boot.initrd.kernelModules = [ "amdgpu" ];
  nixpkgs.config.rocmSupport = true;
}
