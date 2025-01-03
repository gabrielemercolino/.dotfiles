{
  description = "My flake";

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;

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

        wm = "hyprland";
      };

      lib = nixpkgs.lib;

      createNixosProfile =
        name: system:
        lib.nixosSystem {
          inherit system;
          modules = [ ./profiles/${name}/configuration.nix ];
          specialArgs = {
            inherit
              userSettings
              systemSettings
              inputs
              outputs
              ;
          };
        };

      createHomeProfile =
        name: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            overlays = [
              inputs.lite-xl.overlay
            ];
          };
          modules = [ ./profiles/${name}/home.nix ];
          extraSpecialArgs = {
            inherit
              userSettings
              systemSettings
              inputs
              outputs
              ;
          };
        };
    in
    {
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
    nixpkgs.url = "nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:gabrielemercolino/.nixvim";

    stylix.url = "github:danth/stylix/release-24.11";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    hyprland-nix = {
      url = "github:hyprland-community/hyprland-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lite-xl.url = "github:gabrielemercolino/lite-xl-flake";
    #lite-xl.url = "path:/home/gabriele/programmazione/nix/lite-xl-flake";
  };
}
