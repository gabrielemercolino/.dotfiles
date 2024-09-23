{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.socials;
in
{
  options.gab.apps.socials = {
    telegram = lib.mkEnableOption "telegram desktop";
    discord  = lib.mkEnableOption "discord";
  };
  
  config = {
    home.packages = lib.optionals cfg.telegram   [ pkgs.telegram-desktop ]
                    ++ lib.optionals cfg.discord [ pkgs.discord ];
  };
}
