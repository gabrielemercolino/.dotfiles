{ pkgs, userSettings, ... }:

{
  programs.corectrl = {
    enable = true;
    gpuOverclock.enable = true;
  };

  users.users.${userSettings.userName}.extraGroups = [ "corectrl" ];

  environment.systemPackages = [ pkgs.lm_sensors ];
}
