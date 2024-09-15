{ pkgs, userSettings, systemSettings, ... }:

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
  
  networking.hostName = systemSettings.hostName; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = systemSettings.timeZone;
  time.hardwareClockInLocalTime = true; # In case you use dual boot with windows
  
  # Select internationalisation properties.
  i18n.defaultLocale = systemSettings.locale;

  i18n.extraLocaleSettings = {
    LC_ADDRESS = systemSettings.locale;
    LC_IDENTIFICATION = systemSettings.locale;
    LC_MEASUREMENT = systemSettings.locale;
    LC_MONETARY = systemSettings.locale;
    LC_NAME = systemSettings.locale;
    LC_NUMERIC = systemSettings.locale;
    LC_PAPER = systemSettings.locale;
    LC_TELEPHONE = systemSettings.locale;
    LC_TIME = systemSettings.locale;
  };

  # Configure console keymap
  console.keyMap = systemSettings.kb.layout;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [];
  };


  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_ : true);
    permittedInsecurePackages = [];
  };

  environment.systemPackages = [ pkgs.git ];

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  # optimise after every rebuild (not gc) 
  nix.settings.auto-optimise-store = true;
}
