{ config, pkgs, ... }:

{
	wayland.windowManager.hyprland = {
		enable = true;
		xwayland.enable = true;
		settings = {
			"$mod" = "SUPER";
		};
		systemdIntegration = true;
	};

	home.file.".config/hypr/hyprland.conf".source = "./hyprland.conf";
}
