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

    createNixosProfile = name: system: lib.nixosSystem {
      inherit system;
      modules = [ ./profiles/${name}/configuration.nix ];
      specialArgs = { inherit userSettings systemSettings inputs outputs;};
    };

    createHomeProfile = name: system: home-manager.lib.homeManagerConfiguration { 
      pkgs = import nixpkgs { inherit system; };
      modules = [ ./profiles/${name}/home.nix ];
      extraSpecialArgs = { inherit userSettings systemSettings inputs outputs; };
    };
  in {
    nixosConfigurations = {
      mini-pc     = createNixosProfile "mini-pc"     "x86_64-linux";
      chromebook  = createNixosProfile "chromebook"  "x86_64-linux";
    };

    homeConfigurations = {
      mini-pc     = createHomeProfile "mini-pc"     "x86_64-linux";
      chromebook  = createHomeProfile "chromebook"  "x86_64-linux";
    };
  };
}
