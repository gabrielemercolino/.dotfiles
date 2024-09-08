{lib, pkgs, systemSettings, ... }:

let
  baseEnv = {
    "XKB_DEFAULT_LAYOUT" = "${systemSettings.keyLayout}"; # IMPORTANT: gamescope uses american keyboard layout by default

    "-W" = "1980"; # window width
    "-H" = "1080"; # window height
    #"-r" = "60";   # max refresh rate
  };
  baseArgs = [
    "--mangoapp" # mango hud (mainly for test)
    "-f"         # start at full screen
    #"-e"         # enable steam integration
  
    "--force-windows-fullscreen" # force internal game in full screen
  ];
in 
{
  programs.gamescope = {
    enable = true;
    #capSysNice = true; # disabled as for now it's bugged
    package = pkgs.gamescope;
    
    env = lib.mkMerge [
      baseEnv 
      #(lib.mkIf (userSettings.wm == "hyprland") {"--backend" = "wayland";})
    ];
    args = lib.mkMerge [
      baseArgs
      #(lib.mkIf (userSettings.wm == "hyprland") ["--expose-wayland"])
    ];
  };
}
