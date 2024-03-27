{ config, pkgs, ... }:

{
	fonts.packages = with pkgs; [
		(nerdfonts.override { fonts = [ "Inconsolata" "DejaVuSansMono" "JetBrainsMono" "Meslo" ]; })
    font-awesome
    powerline
    material-design-icons
	];
}
