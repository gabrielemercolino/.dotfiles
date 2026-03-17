{
  inputs,
  lib,
  userSettings,
  pkgs,
  ...
}:
{
  imports = [
    ../../gab/nixos
    inputs.sops-nix.nixosModules.sops
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.userName} = {
    isNormalUser = true;
    description = userSettings.name;
    extraGroups = [ "wheel" ];
    packages = [ ];
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.userName}/.config/sops/age/keys.txt";

    secrets = { };
  };

  services.getty.autologinUser = lib.mkDefault userSettings.userName;

  # for battery managment
  services.upower.enable = true;

  # use zsh
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  nix.settings = {
    trusted-users = [ userSettings.userName ];
  };
}
