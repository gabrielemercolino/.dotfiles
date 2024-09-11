{ ... }:

{
  imports = [
    ../base/home.nix

    # gaming
    ../../user/gaming/mangohud.nix

    # music
    ../../user/apps/music

    # general utilities
    ../../user/apps/utilities
  ];

  # for amd gpus
  nixpkgs.config.rocmSupport = true;

  ########################
  #        EDITORS       #
  ########################
  gab.editors.nvim = true;
  gab.editors.intellij = true;
  gab.editors.zed = true;

  ########################
  #         MUSIC        #
  ########################
  gab.music.musics = [
    {
      url = "https://youtu.be/Jrg9KxGNeJY?si=9_DfB4VwSDHVVBL8";
      fileName = "Bury the light";
    }
    {
      url = "https://youtu.be/qKn2lPyAyqQ";
      fileName = "Bury the light - rock";
    }
  ];

  gab.music.spotify = true;
}
