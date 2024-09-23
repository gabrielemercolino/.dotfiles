{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.browsers;
in
{
  options.gab.apps.browsers = {
    chrome  = lib.mkEnableOption "google chrome";
    firefox = lib.mkEnableOption "firefox";
  };

  config = {
    home.packages = lib.optionals cfg.chrome [ pkgs.google-chrome ];
  };
}
