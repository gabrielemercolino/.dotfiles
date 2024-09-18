{
  description = "My flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    nixvim = {
      url = "github:gabrielemercolino/.nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    stylix.url = "github:danth/stylix";
    
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
    systemSettings = {
      hostName = "nixos";
      shell = "zsh";

      dotfiles = "~/.dotfiles";

      # TODO: remove
      kb = {
        layout = "it";
        variation = "";
      };
    };

    userSettings = {
      userName = "gabriele";
      name = "Gabriele";
      email = "gmercolino2003@gmail.com";

      wm = "hyprland";
      browser = "chrome";
      terminal = "kitty";
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      mini-pc = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./profiles/mini-pc/configuration.nix ];
        specialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
        };
      };

      chromebook = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./profiles/chromebook/configuration.nix ];
        specialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
        };
      };
    };

    homeConfigurations = {
      mini-pc = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};

        modules = [ ./profiles/mini-pc/home.nix ];
        extraSpecialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
        };
      };

      chromebook = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [ ./profiles/chromebook/home.nix ];
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
