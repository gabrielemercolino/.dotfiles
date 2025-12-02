{
  lib,
  userSettings,
  pkgs,
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
  # needed for gpu-screen-recorder
  security.wrappers.gsr-kms-server = {
    owner = "root";
    group = "root";
    capabilities = "cap_sys_admin+ep";
    source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
    setuid = false;
    setgid = false;
  };

  # Allow unfree packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
    permittedInsecurePackages = [];
  };

  # whether using x11 or wayland in the end it's better to have it
  services.xserver.enable = true;

  # for battery managment
  services.upower.enable = true;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  system.stateVersion = "24.11";

  nix.settings = {
    trusted-users = [userSettings.userName];

    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];

    # optimise after every rebuild (not gc)
    auto-optimise-store = true;

    # https://wiki.hypr.land/Nix/Cachix/
    substituters = ["https://hyprland.cachix.org"];
    trusted-substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
}
