{ ... }:

{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = -5;
        igpu_desiredgov = "performance";
      };
    };
  };
}