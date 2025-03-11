{
  description = "My flake";

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    systemSettings = {
      hostName = "nixos";

      dotfiles = "~/.dotfiles";

      kb = {
        layout = "it";
        variant = "";
      };
    };

    userSettings = {
      userName = "gabriele";
      name = "Gabriele";
      email = "gmercolino2003@gmail.com";
    };

    inherit (nixpkgs) lib;

    createNixosProfile = name: system:
      lib.nixosSystem {
        inherit system;
        modules = [./profiles/${name}/configuration.nix];
        specialArgs = {
          inherit
            userSettings
            systemSettings
            inputs
            ;
        };
      };

    createHomeProfile = name: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            inputs.lite-xl.overlay
          ];
        };
        modules = [./profiles/${name}/home.nix];
        extraSpecialArgs = {
          inherit
            userSettings
            systemSettings
            inputs
            ;
        };
      };
  in {
    nixosConfigurations = {
      mini-pc = createNixosProfile "mini-pc" "x86_64-linux";
      chromebook = createNixosProfile "chromebook" "x86_64-linux";
    };

    homeConfigurations = {
      mini-pc = createHomeProfile "mini-pc" "x86_64-linux";
      chromebook = createHomeProfile "chromebook" "x86_64-linux";
    };
  };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:gabrielemercolino/.nixvim";
    nvf = {
      url = "github:gabrielemercolino/.nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    hyprland-nix = {
      url = "github:hyprland-community/hyprland-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lite-xl = {
      url = "github:gabrielemercolino/lite-xl-flake";
      #url = "path:/home/gabriele/programmazione/nix/lite-xl-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };
}
