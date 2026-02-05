{
  inputs,
  userSettings,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/${userSettings.userName}/.config/sops/age/keys.txt";

    secrets = {
      "ssh/priv" = {
        owner = userSettings.userName;
        path = "/home/${userSettings.userName}/.ssh/id_ed25519";
      };
      "ssh/pub" = {
        owner = userSettings.userName;
        path = "/home/${userSettings.userName}/.ssh/id_ed25519.pub";
      };
    };
  };
}
