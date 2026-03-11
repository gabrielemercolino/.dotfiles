{self, ...}: {
  flake.nixosModules.networking = {config, ...}: {
    imports = [self.nixosModules.user];

    users.users.${config.gab.user.name}.extraGroups = ["networkmanager"];

    networking.networkmanager.enable = true;
  };
}
