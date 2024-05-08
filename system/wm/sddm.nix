{ pkgs, userSettings, ... }:

{
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtquickcontrols2   
    libsForQt5.qt5.qtgraphicaleffects
  ]; 

  services = {
    displayManager.sddm = {
      enable = true;
      enableHidpi = true;
      wayland.enable = true;
      autoNumlock = true;
      package = pkgs.sddm; 

      theme = "${ import (./. + ("../../../themes/" + userSettings.theme + "/sddm-theme.nix")) { inherit pkgs; } }";
    };    
  };
}
