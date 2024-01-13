{ config, pkgs, ... }:

{
	wayland.windowManager.hyprland = {
		enable = true;
		xwayland.enable = true;
		settings = {
			"$mod" = "SUPER";
		};
	};
}
