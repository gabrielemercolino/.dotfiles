{ config, lib, pkgs, userSettings, ... }:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    control = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          corectrl  = lib.mkEnableOption "corectrl";
          lact      = lib.mkEnableOption "lact";
        };
      };

      default = {
        corectrl  = false;
        lact      = false;
      };
    }; 

    dev = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          direnv = lib.mkEnableOption "nix-direnv";
          docker = lib.mkEnableOption "docker";
        };
      };

      default = {
        direnv = false;
        docker = false;
      };
    };

    security = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          ssh = lib.mkEnableOption "ssh";
        };
      };

      default = {
        ssh = false;
      };
    };

    services = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          dbus = lib.mkEnableOption "dbus";
        };
      };

      default = {
        dbus = false;
      };
    };
  };

  config = {
    users.users.${userSettings.userName}.extraGroups = lib.optionals cfg.control.corectrl [ "corectrl" ]
                                                       ++ lib.optionals cfg.dev.docker [ "docker" ];

    environment.systemPackages = lib.optionals cfg.control.corectrl [ pkgs.lm_sensors ] 
                                 ++ lib.optionals cfg.control.lact [ pkgs.lact ];

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
      enable = cfg.services.dbus;
      packages = [ pkgs.dconf ];
    };
    programs.dconf.enable = cfg.services.dbus;

  };
}
