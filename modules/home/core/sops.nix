{ self, ... }:
{
  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.sops ];

    sops =
      { user, ... }:
      {
        sops = {
          defaultSopsFile = self.outPath + "/secrets/secrets.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
