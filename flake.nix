{
  description = "My flake";

  inputs = {
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
     url = "github:nix-community/home-manager";
     inputs.nixpkgs.follows = "nixpkgs";
    };
   
    nixvim.url = "github:gabrielemercolino/.nixvim";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs-unstable,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
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

      theme = "catppuccin-mocha";

      # TODO: make it easier to use
      font = "JetBrainsMono Nerd Font"; # Selected font
      fontPkg = (pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; }); # Font package
    };

    lib = nixpkgs.lib;
    pkgs = import nixpkgs {system = systemSettings.system;};
    pkgs-unstable = import nixpkgs-unstable {system = systemSettings.system;};
    
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
          inherit pkgs-unstable;

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
          inherit pkgs-unstable;

          inherit (inputs) stylix;
        };
      };
    };
  };
}
