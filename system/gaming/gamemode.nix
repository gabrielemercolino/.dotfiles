{ userSettings, ... }:

{
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        renice = 5;
        igpu_desiredgov = "performance";
      };
    };
  };

  # neeed to make the renice setting work 
  users.users.${userSettings.userName}.extraGroups = [ "gamemode" ];
}
