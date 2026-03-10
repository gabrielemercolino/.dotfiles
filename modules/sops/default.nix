{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.sops = {config, ...}: {
    imports = [inputs.sops-nix.nixosModules.sops self.nixosModules.user];

    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "/home/${config.gab.user.name}/.config/sops/age/keys.txt";

      secrets = {};
    };
  };

  flake.homeModules.sops = {config, ...}: {
    imports = [inputs.sops-nix.homeModules.sops];

    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";

      secrets = {
        "ssh/priv" = {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
        };
        "ssh/pub" = {
          path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };
      };
    };
  };
}
