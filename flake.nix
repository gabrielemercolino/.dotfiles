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
    stylix,
    spicetify-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    
    systemSettings = {
      hostName = "nixos";
      shell = "zsh";

      dotfiles = "~/.dotfiles";

      kb = {
        layout = "it";
        variation = "";
      };

      timeZone = "Europe/Rome";
      locale = "it_IT.UTF-8";
    };

    userSettings = {
      userName = "gabriele";
      name = "Gabriele";

      wm = "hyprland";
      browser = "chrome";
      terminal = "kitty";
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      base = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./profiles/base/configuration.nix ];
        specialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;

          inherit (inputs) stylix;
        };
      };

      mini-pc = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./profiles/mini-pc/configuration.nix ];
        specialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;

          inherit (inputs) stylix;
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

          inherit (inputs) stylix;
        };
      };
    };

    homeConfigurations = {
      base = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};
        modules = [ ./profiles/base/home.nix ];
        extraSpecialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;

          inherit (inputs) stylix;
        };
      };

      mini-pc = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {system = "x86_64-linux";};

        modules = [ ./profiles/mini-pc/home.nix ];
        extraSpecialArgs = {
          inherit userSettings;
          inherit systemSettings;
          inherit inputs;
          inherit outputs;
          inherit spicetify-nix;

          inherit (inputs) stylix;
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
          inherit spicetify-nix;

          inherit (inputs) stylix;
        };
      };

    };
  };
}
