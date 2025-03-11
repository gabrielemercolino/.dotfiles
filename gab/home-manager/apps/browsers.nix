{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    chrome.enable = lib.mkEnableOption "google chrome";
    firefox.enable = lib.mkEnableOption "firefox";
    zen.enable = lib.mkEnableOption "zen browser";
  };

  config = {
    home.packages =
      lib.optionals cfg.chrome.enable [pkgs.google-chrome]
      ++ lib.optionals cfg.firefox.enable [pkgs.firefox]
      ++ lib.optionals cfg.zen.enable [inputs.zen-browser.packages.${pkgs.system}.default];
  };
}
