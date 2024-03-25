{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:gabrielemercolino/.nixvim";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
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

      theme = "default";

      # TODO: make it easier to use
      font = "Font Awesome"; # Selected font
      fontPkg = pkgs.font-awesome; # Font package
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

          inherit (inputs) stylix;
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

          inherit (inputs) stylix;
        };
      };
    };
  };
}
