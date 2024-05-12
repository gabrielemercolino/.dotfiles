{
  description = "My flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.11";
    
    home-manager-stable = {
     url = "github:nix-community/home-manager/release-23.11";
     inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    nixvim.url = "github:gabrielemercolino/.nixvim";

    stylix.url = "github:danth/stylix";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager-stable,
    home-manager-unstable,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib;
    
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

    pkgs = (if (systemSettings.profile == "work") 
    then
      import nixpkgs {system = systemSettings.system;}
    else
      import nixpkgs-stable { system = systemSettings.system;}
    );

    unstable-pkgs = import nixpkgs-stable {system = systemSettings.system;};
    stable-pkgs = import nixpkgs {system = systemSettings.system;};
    
    home-manager = (if (systemSettings.profile == "work") 
    then
      inputs.home-manager-unstable
    else
      inputs.home-manager-stable
    );

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
          inherit stable-pkgs;
          inherit unstable-pkgs;

          inherit (inputs) stylix;
        };
      };
    };
  };
}
