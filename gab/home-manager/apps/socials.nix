{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    telegram = lib.mkEnableOption "telegram desktop";
    discord  = lib.mkEnableOption "discord";
  };
  
  config = {
    home.packages = lib.optionals cfg.telegram   [ pkgs.telegram-desktop ]
                    ++ lib.optionals cfg.discord [ pkgs.discord ];
  };
}
