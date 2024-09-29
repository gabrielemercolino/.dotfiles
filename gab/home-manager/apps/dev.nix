{ config, lib, ... }:

with lib.types;

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    git = {
      enable    = lib.mkEnableOption "git";
      userName  = lib.mkOption { type = nullOr str; default = null; };
      userEmail = lib.mkOption { type = nullOr str; default = null; };
    };
  };

  config = {
    programs.git = {
      enable    = cfg.git.enable;
      userName  = cfg.git.userName;
      userEmail = cfg.git.userEmail;
    };
  };
}
