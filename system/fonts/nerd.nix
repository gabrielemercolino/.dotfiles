{ config, pkgs, ... }:

{
	fonts.packages = with pkgs; [
		nerdfonts
	];
}
