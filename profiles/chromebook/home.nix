{ ... }:

{
  imports = [
    ../base/home.nix

    # editors
    ../../user/apps/editors/jetbrains.nix

    # utilities
    ../../user/apps/utilities

    # music
    ../../user/apps/music/spicetify.nix
  ];
}
