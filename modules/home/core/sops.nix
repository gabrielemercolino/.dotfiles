{ self, inputs, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.sops ];

    sops =
      { lib, host, user, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        sops = {
          defaultSopsFile = self.outPath + "/secrets/${host.name}.yaml";
          defaultSopsFormat = "yaml";
          # an ephemeral root keeps the key on the persistent volume instead
          age.keyFile = lib.mkDefault "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
