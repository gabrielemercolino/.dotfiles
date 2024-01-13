{ config, pkgs, ... }:

{
	wayland.windowManager.hyprland = {
	    # Whether to enable Hyprland wayland compositor
	    enable = true;
	    # The hyprland package to use
	    package = pkgs.hyprland;
	    # Whether to enable XWayland
	    xwayland.enable = true;		
	
	    # Optional
	    # Whether to enable hyprland-session.target on hyprland startup
	    systemd.enable = true;
	    # Whether to enable patching wlroots for better Nvidia support
	    enableNvidiaPatches = true;
	};

	wayland.windowManager.hyprland.settings = {
	    "$mod" = "SUPER";
	    bind =
	      [
	        "$mod, RETURN, exec, kitty"
		"$mod, Q, killactive," 
		"$mod, M, exit, "
		"$mod, E, exec, dolphin"
		"$mod, V, togglefloating, "
		"$mod, R, exec, rofi -show drun"
		"$mod, P, pseudo, # dwindle"
		"$mod, J, togglesplit," # dwindle
	      ]
	      ++ (
	        # workspaces
	        # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
	        builtins.concatLists (builtins.genList (
	            x: let
	              ws = let
	                c = (x + 1) / 10;
	              in
	                builtins.toString (x + 1 - (c * 10));
	            in [
	              "$mod, ${ws}, workspace, ${toString (x + 1)}"
	              "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
	            ]
	          )
	          10)
	      );
	  };

	home.packages = with pkgs; [
		kitty
		rofi
	];
}
