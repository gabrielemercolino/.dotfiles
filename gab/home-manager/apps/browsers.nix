{ config, lib, pkgs, ... }:

let
  cfg = config.gab.apps.browsers;
in
{
  config = {
    home.packages = lib.optionals cfg.chrome [ pkgs.google-chrome ];
  };
}
