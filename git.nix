{ config, pkgs, ... }:

{
	programs.git = {
		enable = true;
		userName = "gabrielemercolino";
		userEmail = "gmercolino2003@gmail.com";
	};
}
