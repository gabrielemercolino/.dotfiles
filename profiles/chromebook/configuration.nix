{ ... }:

{
  imports = [
    ../base/configuration.nix

    # development
    ../../system/virtualization/docker.nix
  ];
}
