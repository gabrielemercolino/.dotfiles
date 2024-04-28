{ config, pkgs, ... }:

{
	programs.git = {
		enable = true;
		userName = "Gabriele Mercolino";
		userEmail = "gmercolino2003@gmail.com";
	};
}
