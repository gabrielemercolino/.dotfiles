{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    corectrl.enable = lib.mkEnableOption "corectrl";
    lact.enable = lib.mkEnableOption "lact";
    direnv.enable = lib.mkEnableOption "direnv";
    docker.enable = lib.mkEnableOption "docker";
    ssh.enable = lib.mkEnableOption "ssh";
    dbus.enable = lib.mkEnableOption "dbus";
    bashmount.enable = lib.mkEnableOption "bashmount (with udisk2)";
    wireshark.enable = lib.mkEnableOption "wireshark";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups =
      lib.optionals cfg.corectrl.enable ["corectrl"]
      ++ lib.optionals cfg.docker.enable ["docker"]
      ++ lib.optionals cfg.wireshark.enable ["wireshark"];

    environment.systemPackages =
      lib.optionals cfg.corectrl.enable [pkgs.lm_sensors]
      ++ lib.optionals cfg.lact.enable [pkgs.lact]
      ++ lib.optionals cfg.bashmount.enable [pkgs.bashmount];

    # Control related stuff
    programs.corectrl = {
      enable = cfg.corectrl.enable;
      gpuOverclock.enable = true;
    };

    ## lact needs its daemon to properly work
    systemd.services.lact = {
      enable = cfg.lact.enable;
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig.ExecStart = "${pkgs.lact}/bin/lact daemon";
    };

    # dev related stuff
    programs.direnv.enable = cfg.direnv.enable;
    virtualisation.docker.enable = cfg.docker.enable;

    # security related stuff
    services.openssh.enable = cfg.ssh.enable;

    # services related stuff
    services.dbus = {
      enable = cfg.dbus.enable;
      packages = [pkgs.dconf];
    };
    programs.dconf.enable = cfg.dbus.enable;

    # needed for bashmount
    services.udisks2.enable = cfg.bashmount.enable;

    programs.wireshark = {
      enable = cfg.wireshark.enable;
      package = pkgs.wireshark;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
  };
}
