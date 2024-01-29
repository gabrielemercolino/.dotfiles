{ config, pkgs, ... }:
let
	myShellAliases =  {
		ll = "ls -l";
		niu = "cd ~/.dotfiles && sudo nixos-rebuild switch --flake .#system";
		hmu = "cd ~/.dotfiles && home-manager switch --flake .#user";
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
