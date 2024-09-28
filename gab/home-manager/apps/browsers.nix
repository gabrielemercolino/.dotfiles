{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.browsers;
in
{
  options.gab.apps.browsers = {
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
