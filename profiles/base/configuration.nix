{ userSettings, systemSettings, ... }:

{
  imports =
    [
      ../../system/hardware-configuration.nix
      (./. + "../../../system/shell"+("/"+systemSettings.shell)+".nix")
      ../../system/services
      ../../system/fonts
      (../../system/wm + ("/" + userSettings.wm))
      ../../system/style
      ../../system/apps/nix-direnv.nix
      ../../system/apps/corectrl.nix
    ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "wheel" ];
    packages = [];
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_ : true);
    permittedInsecurePackages = [];
  };

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  # optimise after every rebuild (not gc) 
  nix.settings.auto-optimise-store = true;
}
