{ self, inputs, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.sops ];

    sops =
      {
        lib,
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
          # an ephemeral root cannot read a key from /home during activation;
          # such hosts override this with a path on a neededForBoot volume
          age.keyFile = lib.mkDefault "/home/${user.name}/.config/sops/age/keys.txt";
        };
      };
  };
}
