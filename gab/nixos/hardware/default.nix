{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
with lib.types; let
  cfg = config.gab.hardware;
in {
  imports = [
    ./audio.nix
    ./localization.nix
  ];

  options.gab.hardware = {
    bluetooth.enable = lib.mkEnableOption "bluetooth";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = [
      "networkmanager"
    ];

    ## graphics related settings
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    ## bluetooth
    hardware.bluetooth.enable = cfg.bluetooth.enable;
    hardware.bluetooth.powerOnBoot = false;

    ## networking related settings
    networking.hostName = lib.mkDefault "nixos";
    networking.networkmanager.enable = lib.mkDefault true; # provide by default network access with networkmanager
  };
}
