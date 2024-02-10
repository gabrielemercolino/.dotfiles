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
		pkgs = nixpkgs.legacyPackages.${system};
		
		systemSettings = rec {
			system = "x86_64-linux";
			dotfiles = "~/.dotfiles";
			profile = "personal";

			timeZone = "Europe/Rome";
			locale = "it_IT.UTF-8";
		};

		userSettings = rec {
			userName = "gabriele";
			name = "Gabriele";

			wm = "hyprland";
			browser = "chrome";
			terminal = "kitty";
			font = "nerd";
		};

	in {
		nixosConfigurations = {
			system = lib.nixosSystem {
				system = systemSettings.system;
				modules = [ (./. + "/profiles"+("/"+systemSettings.profile)+"/configuration.nix") ];
				specialArgs = {
					inherit userSettings;
					inherit systemSettings;
				};
			};
		};
		
		homeConfigurations = {
			user = home-manager.lib.homeManagerConfiguration {
				inherit pkgs;
				modules = [  (./. + "/profiles"+("/"+systemSettings.profile)+"/home.nix") ];
				extraSpecialArgs = {
					inherit userSettings;
					inherit systemSettings;
				};
			};
		};	
	};
}
