{
  lib,
  userSettings,
  ...
}: {
  users.users.${userSettings.userName}.extraGroups = ["networkmanager"];

  networking.hostName = lib.mkDefault "nixos";
  networking.networkmanager.enable = lib.mkDefault true; # provide by default network access with networkmanager
}
