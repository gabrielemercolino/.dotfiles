{ pkgs, ... }:

{
  imports = [
    ../base/configuration.nix

    # development
    ../../system/virtualization/docker.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
}
