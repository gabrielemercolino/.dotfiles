{ self, inputs, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.sops ];

    sops =
      {
        pkgs,
        host,
        user,
        ...
      }:
      {
        imports = [ inputs.sops-nix.nixosModules.sops ];

        environment.systemPackages = [ pkgs.sops ];

        sops = {
          defaultSopsFile = self.outPath + "/secrets/${host.name}.yaml";
          defaultSopsFormat = "yaml";
          age.keyFile = "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
