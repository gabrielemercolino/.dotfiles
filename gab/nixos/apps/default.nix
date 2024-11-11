{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    corectrl.enable = lib.mkEnableOption "corectrl";
    lact.enable = lib.mkEnableOption "lact";
    direnv.enable = lib.mkEnableOption "direnv";
    docker.enable = lib.mkEnableOption "docker";
    ssh.enable = lib.mkEnableOption "ssh";
    dbus.enable = lib.mkEnableOption "dbus";
  };

  config = {
    users.users.${userSettings.userName}.extraGroups =
      lib.optionals cfg.corectrl.enable [ "corectrl" ]
      ++ lib.optionals cfg.docker.enable [ "docker" ];

    environment.systemPackages =
      lib.optionals cfg.corectrl.enable [ pkgs.lm_sensors ]
      ++ lib.optionals cfg.lact.enable [ pkgs.lact ];

    # Control related stuff
    programs.corectrl = {
      enable = cfg.corectrl.enable;
      gpuOverclock.enable = true;
    };

    ## lact needs its daemon to properly work
    systemd.services.lact = {
      enable = cfg.lact.enable;
      description = "AMDGPU Control Daemon";
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
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
      packages = [ pkgs.dconf ];
    };
    programs.dconf.enable = cfg.dbus.enable;
  };
}
