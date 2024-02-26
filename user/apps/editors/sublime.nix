{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
			sublime4
	];
}
