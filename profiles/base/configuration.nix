{ lib, userSettings, ... }:

{
  imports = [ ../../system/hardware-configuration.nix ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "wheel" ];
    packages = [];
  };

  services.getty.autologinUser = lib.mkDefault userSettings.userName;

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_ : true);
    permittedInsecurePackages = [];
  };

  # whether using x11 or wayland in the end it's better to have it
  services.xserver.enable = true;

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  # optimise after every rebuild (not gc) 
  nix.settings.auto-optimise-store = true;
}
