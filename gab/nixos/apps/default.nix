{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    control = {
      corectrl = lib.mkEnableOption "corectrl";
      lact     = lib.mkEnableOption "lact";  
    };

    dev = {
      direnv = lib.mkEnableOption "direnv";
      docker = lib.mkEnableOption "docker";
    };

    security = {
      ssh = lib.mkEnableOption "ssh";
    };
    
    services = {
      dbus = lib.mkEnableOption "dbus";
    };
    
    wm = {
      bspwm    = lib.mkEnableOption "bspwm";
      hyprland = lib.mkEnableOption "hyprland";
    };
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.control.corectrl [ "corectrl" ]
                                                       ++ lib.optionals cfg.dev.docker    [ "docker" ];

    environment.systemPackages = lib.optionals cfg.control.corectrl [ pkgs.lm_sensors ] 
                                 ++ lib.optionals cfg.control.lact  [ pkgs.lact ];

    # Control related stuff
    programs.corectrl = {
      enable = cfg.control.corectrl;
      gpuOverclock.enable = true;
    };

    ## lact needs its daemon to properly work
    systemd.services.lact = {
      enable      = cfg.control.lact;
      description = "AMDGPU Control Daemon";
      after       = ["multi-user.target"];
      wantedBy    = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    # dev related stuff
    programs.direnv.enable = cfg.dev.direnv;
    virtualisation.docker.enable = cfg.dev.docker;

    # security related stuff
    services.openssh.enable = cfg.security.ssh;

    # services related stuff
    services.dbus = {
      enable    = cfg.services.dbus;
      packages  = [ pkgs.dconf ];
    };
    programs.dconf.enable = cfg.services.dbus;

    # wm related stuff
    services.xserver.windowManager.bspwm = {
      enable  = cfg.wm.bspwm;
      package = pkgs.bspwm; 
    };
    programs.hyprland = {
      enable          = cfg.wm.hyprland;
      xwayland.enable = true;
      portalPackage   = pkgs.xdg-desktop-portal-hyprland;
    };
  };
}
