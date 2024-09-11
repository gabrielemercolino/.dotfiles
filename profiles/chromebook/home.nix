{ ... }:

{
  imports = [
    ../base/home.nix

    # editors
    ../../user/apps/editors

    # utilities
    ../../user/apps/utilities
  ];

  gab.editors.intellij = true;
}
