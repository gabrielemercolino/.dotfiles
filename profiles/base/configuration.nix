{
  lib,
  userSettings,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = ["wheel"];
    packages = [];
  };

  services.getty.autologinUser = lib.mkDefault userSettings.userName;
  # to enable swaylock with any compositor other than sway this is needed
  security.pam.services.swaylock = lib.mkDefault {};

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [];
  };

  # whether using x11 or wayland in the end it's better to have it
  services.xserver.enable = true;

  system.stateVersion = "24.11";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # optimise after every rebuild (not gc)
  nix.settings.auto-optimise-store = true;
}
