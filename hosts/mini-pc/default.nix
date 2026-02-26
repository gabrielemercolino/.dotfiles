{
  inputs,
  self,
  ...
}: let
  username = "gabriele";
in {
  flake.nixosConfigurations.mini-pc = inputs.nixpkgs.lib.nixosSystem {
    modules = [self.nixosModules.mini-pc];
  };

  flake.homeConfigurations.mini-pc = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [self.homeModules.mini-pc];
  };

  flake.nixosModules.mini-pc = {...}: {
    imports = [./_hardware-configuration.nix self.nixosModules.common];

    gab = {
      user.name = username;

      wm = {
        hyprland.enable = true;
      };

      # apps = {};

      gaming = {
        steam.enable = true;
      };
    };
  };

  flake.homeModules.mini-pc = {...}: {
    imports = [self.homeModules.common];

    gab = {
      user.name = username;
    };
  };
}
