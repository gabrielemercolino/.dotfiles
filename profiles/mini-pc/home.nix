{ ... }:

{
  imports = [
    ../base/home.nix

    # editors
    ../../user/apps/editors/jetbrains.nix
    ../../user/apps/editors/zed.nix

    # music
    ../../user/apps/music/spicetify.nix

    # general utilities
    ../../user/apps/utilities
  ];
}
