{ ... }:

{
  imports = [
    ../base/home.nix

    # editors
    ../../user/apps/editors/jetbrains.nix
    ../../user/apps/editors/zed.nix

    # general utilities
    ../../user/apps/utilities
  ];
}
