{ pkgs, userSettings, ... }:

{
  programs.steam.enable = true;

  programs.steam.gamescopeSession = {
    enable = true;
    env = {};
    args = [];
  };

  environment.systemPackages = with pkgs; [ mangohud protonup ];

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/" + userSettings.userName + "/.steam/root/compatibilitytools.d";
  };
}
