{ config, ... }:

let
  cfg = config.gab.apps.dev;
in
{
  programs.git = {
    enable    = cfg.git.enable;
    userName  = cfg.git.userName;
    userEmail = cfg.git.userEmail;
  };
}
