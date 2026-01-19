{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  imports = [./configs/zen];

  options.gab.apps = {
    chrome.enable = lib.mkEnableOption "google chrome";
    firefox.enable = lib.mkEnableOption "firefox";
  };

  config = {
    home.packages =
      lib.optionals cfg.chrome.enable [pkgs.google-chrome]
      ++ lib.optionals cfg.firefox.enable [pkgs.firefox];
  };
}
