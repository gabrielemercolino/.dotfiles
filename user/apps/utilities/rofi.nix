{ 
  pkgs,
  wayland ? false
}:

{
  programs.rofi = {
    enable = true;
    package = if wayland then pkgs.rofi-wayland else pkgs.rofi;
    extraConfig = {
      modi = "drun";
      show-icons = true;
      icon-theme = "WhiteSur";
      display-drun = "";
      display-run = "";
      display-filebrowser = "";
      display-window = "";
      display-emoji = "󰞅";
      display-clipboard = "";
      drun-display-format = "{name}";
      window-format = "{t}";
    };
  };
}
