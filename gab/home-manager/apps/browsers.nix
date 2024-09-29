{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    chrome  = lib.mkEnableOption "google chrome";
    firefox = lib.mkEnableOption "firefox";
    zen     = lib.mkEnableOption "zen browser";
  };

  config = {
    home.packages = lib.optionals cfg.chrome     [ pkgs.google-chrome ]
                    ++ lib.optionals cfg.firefox [ pkgs.firefox ]
                    ++ lib.optionals cfg.zen     [ (pkgs.callPackage ./custom-derivations/zen-browser.nix {}) ];
  };
}
