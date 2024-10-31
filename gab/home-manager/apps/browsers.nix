{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    chrome.enable  = lib.mkEnableOption "google chrome";
    firefox.enable = lib.mkEnableOption "firefox";
    zen = {
      enable   = lib.mkEnableOption "zen browser";
      specific = lib.mkEnableOption "specific mode for zen-browser";
    };
  };

  config = {
    home.packages = lib.optionals cfg.chrome.enable  [ pkgs.google-chrome ]
                    ++ 
                    lib.optionals cfg.firefox.enable [ pkgs.firefox ]
                    ++ 
                    lib.optionals cfg.zen.enable     [ (pkgs.callPackage ./custom-derivations/zen-browser.nix {specific = cfg.zen.specific;}) ];
  };
}
