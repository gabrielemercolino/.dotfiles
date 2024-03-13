{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager/release-23.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:gabrielemercolino/.nixvim";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${systemSettings.system};

    systemSettings = rec {
      system = "x86_64-linux";
      hostName = "nixos";

      dotfiles = "~/.dotfiles";
      profile = "work";

      keyLayout = "it";

      timeZone = "Europe/Rome";
      locale = "it_IT.UTF-8";
    };

    userSettings = rec {
      userName = "gabriele";
      name = "Gabriele";

      wm = "hyprland";
      browser = "chrome";
      terminal = "kitty";
      font = "nerd";
    };
  in {
    nixosConfigurations = {
      system = lib.nixosSystem {
        system = systemSettings.system;
        modules = [(./. + "/profiles" + ("/" + systemSettings.profile) + "/configuration.nix")];
        specialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
        };
      };
    };

    homeConfigurations = {
      user = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [(./. + "/profiles" + ("/" + systemSettings.profile) + "/home.nix")];
        extraSpecialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
        };
      };
    };
  };
}
