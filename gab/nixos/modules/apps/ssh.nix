{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    ssh.enable = lib.mkEnableOption "ssh";
  };

  config = {
    services.openssh.enable = cfg.ssh.enable;
  };
}
