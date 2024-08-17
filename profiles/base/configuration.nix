{ config, pkgs, userSettings, systemSettings, ... }:

{
  imports =
    [
      ../../system/hardware-configuration.nix
      ../../system/hardware
      (./. + "../../../system/shell"+("/"+systemSettings.shell)+".nix")
      ../../system/services
      ../../system/fonts
      (./. + "../../../system/wm"+("/"+userSettings.wm)+".nix")
      ../../system/style/stylix.nix
      ../../system/apps/nix-direnv.nix
      ../../system/apps/corectrl.nix
    ];

  
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
  console.keyMap = systemSettings.keyLayout;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };


  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = (_ : true);
    permittedInsecurePackages = [
      #"openssl-1.1.1w"  # for sublime
    ];
  };

  environment.systemPackages = with pkgs; [ git ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "23.11";

  nix.settings.experimental-features = ["nix-command" "flakes" ];
  
  # optimise after every rebuild (not gc) 
  nix.settings.auto-optimise-store = true;
}
