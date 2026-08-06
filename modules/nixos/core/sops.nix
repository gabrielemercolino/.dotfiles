{ self, inputs, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.sops ];

    sops =
      { user, ... }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        sops = {
          defaultSopsFile = self.outPath + "/secrets/secrets.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
