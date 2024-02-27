{ config, pkgs, userSettings, ... }:

{
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  users.users.${userSettings.userName} = {
    extraGroups = [ "audio" ];
  };
}