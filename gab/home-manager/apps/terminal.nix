{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.terminal;
in
{
  config = {
    home.packages = lib.optionals cfg.warp [ pkgs.warp-terminal ];

    programs.kitty = {
		  enable = cfg.kitty;
		  settings = {
        confirm_os_window_close = 0;
		  };
	  };
  };
}
