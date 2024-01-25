{ config, pkgs, ... }:
let
	myShellAliases =  {
		ll = "ls -l";
		niu = "sudo nixos-rebuild switch --flake ~/.dotfiles/";
		hmu = "home-manager switch --flake ~/.dotfiles/";
  	};
in

{
	programs.bash = {
		enable = true;
		shellAliases = myShellAliases;
	};

	programs.zsh = {
		enable = true; 
 		shellAliases = myShellAliases;
		oh-my-zsh = {
			enable = true;
			theme = "robbyrussell";
			plugins = ["git" "sudo"];
		};
		syntaxHighlighting.enable = true;
  };

}
