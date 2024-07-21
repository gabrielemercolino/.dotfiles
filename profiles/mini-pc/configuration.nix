{ ... }:

{
  imports = [
    ../base/configuration.nix

    # gaming
    ../../system/gaming/steam.nix
    ../../system/gaming/lutris.nix
    ../../system/gaming/bottles.nix

    # development
    ../../system/virtualization/docker.nix
  ];
}
