{ config, pkgs, ... }:

{
	home.packages = with pkgs; [
	  # bin = latest 🙄
    jetbrains.idea-community-bin
	];
}
