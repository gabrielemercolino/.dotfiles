{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    corectrl = lib.mkEnableOption "corectrl";
    lact     = lib.mkEnableOption "lact";  

    direnv = lib.mkEnableOption "direnv";
    docker = lib.mkEnableOption "docker";

    ssh  = lib.mkEnableOption "ssh";
    dbus = lib.mkEnableOption "dbus";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.corectrl [ "corectrl" ]
                                                       ++ 
                                                       lib.optionals cfg.docker   [ "docker" ];

    environment.systemPackages = lib.optionals cfg.corectrl [ pkgs.lm_sensors ] 
                                 ++ 
                                 lib.optionals cfg.lact     [ pkgs.lact ];

    # Control related stuff
    programs.corectrl = {
      enable = cfg.corectrl;
      gpuOverclock.enable = true;
    };

    ## lact needs its daemon to properly work
    systemd.services.lact = {
      enable      = cfg.lact;
      description = "AMDGPU Control Daemon";
      after       = ["multi-user.target"];
      wantedBy    = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    # dev related stuff
    programs.direnv.enable       = cfg.direnv;
    virtualisation.docker.enable = cfg.docker;

    # security related stuff
    services.openssh.enable = cfg.ssh;

    # services related stuff
    services.dbus = {
      enable    = cfg.dbus;
      packages  = [ pkgs.dconf ];
    };
    programs.dconf.enable = cfg.dbus;
  };
}
