{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
			meson
			ninja
	];
}