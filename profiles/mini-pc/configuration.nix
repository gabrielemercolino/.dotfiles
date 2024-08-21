{ ... }:

{
  imports = [
    ../base/configuration.nix

    # gaming
    ../../system/gaming/steam.nix
    ../../system/gaming/gamescope.nix
    ../../system/gaming/gamemode.nix
    #../../system/gaming/lutris.nix
    #../../system/gaming/bottles.nix

    # control
    ../../system/apps/lact.nix

    # development
    ../../system/virtualization/docker.nix
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
}
