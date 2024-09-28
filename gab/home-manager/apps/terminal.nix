{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.terminal;
in
{
  options.gab.apps.terminal = {
    alacritty = lib.mkEnableOption "alacritty";
    kitty     = lib.mkEnableOption "kitty";
    warp      = lib.mkEnableOption "warp";
  };

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