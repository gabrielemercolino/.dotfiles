{
	description = "My flake";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
		home-manager.url = "github:nix-community/home-manager/release-23.11";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = { self, nixpkgs, home-manager, ... } : 
	let
		lib = nixpkgs.lib;
		system = "x86_64-linux";
		pkgs = nixpkgs.legacyPackages.${system};
		systemSettings = rec {
			profile = "work";
		};
		userSettings = rec {
			windowManager = "hyprland";
			browser = "chrome";
			terminal = "kitty";
		};
	in {
		nixosConfigurations = {
			nixos = lib.nixosSystem {
				inherit system;
				modules = [ ./configuration.nix ];
			};
		};
		
		homeConfigurations = {
			gabriele = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				#modules = [ ./home.nix ];
				modules = [  (./. + "/profiles"+("/"+systemSettings.profile)+"/home.nix") ];
				extraSpecialArgs = {
					inherit userSettings;
				};
			};
		};	
	};
}
