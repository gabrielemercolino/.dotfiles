{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.socials;
in
{
  home.packages = lib.optionals cfg.telegram   [ pkgs.telegram-desktop ]
                  ++ lib.optionals cfg.discord [ pkgs.discord ];
}
