{ ... }:

{
  imports = [
    ../base/home.nix

    # gaming
    ../../user/gaming/mangohud.nix

    # editors
    ../../user/apps/editors/jetbrains.nix
    ../../user/apps/editors/zed.nix

    # music
    ../../user/apps/music/spicetify.nix

    # general utilities
    ../../user/apps/utilities
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;
}
