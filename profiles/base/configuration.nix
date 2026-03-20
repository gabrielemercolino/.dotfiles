{
  inputs,
  userSettings,
  ...
}:
{
  imports = [
    ../../gab/nixos
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.userName}/.config/sops/age/keys.txt";

    secrets = { };
  };

  # for battery managment
  services.upower.enable = true;
}
