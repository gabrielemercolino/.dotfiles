{ self, inputs, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.sops ];

    sops =
      { host, user, ... }:
      {
        imports = [ inputs.sops-nix.homeManagerModules.sops ];

        sops = {
          defaultSopsFile = self.outPath + "/secrets/${host.name}.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
