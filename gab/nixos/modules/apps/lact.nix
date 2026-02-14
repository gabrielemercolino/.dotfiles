{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    lact.enable = lib.mkEnableOption "lact";
  };

  config = {
    environment.systemPackages = lib.optionals cfg.lact.enable [pkgs.lact];

    ## lact needs its daemon to properly work
    systemd.services.lact = {
      enable = cfg.lact.enable;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
    };
  };
}
