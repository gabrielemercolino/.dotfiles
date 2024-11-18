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
              inputs.hyprpanel.overlay
              (final: prev: {
                bun =
                  if name == "chromebook" then
                    prev.bun.overrideAttrs (oldAttrs: {
                      passthru.sources."x86_64-linux" = final.fetchurl {
                        url = "https://github.com/oven-sh/bun/releases/download/bun-v${oldAttrs.version}/bun-linux-x64-baseline.zip";
                        hash = "";
                      };
                    })
                  else
                    prev.bun;
              })
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
    nixpkgs.url = "nixpkgs/release-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim.url = "github:gabrielemercolino/.nixvim";

    stylix.url = "github:danth/stylix";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    hyprland-nix = {
      url = "github:hyprland-community/hyprland-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
  };
}
