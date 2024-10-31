{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    kitty.enable = lib.mkEnableOption "kitty";
    warp.enable  = lib.mkEnableOption "warp";
  };

  config = {
    home.packages = lib.optionals cfg.warp.enable [ pkgs.warp-terminal ];

    programs.kitty = {
		  enable = cfg.kitty.enable;
		  settings = {
        confirm_os_window_close = 0;
		  };
	  };
  };
}
