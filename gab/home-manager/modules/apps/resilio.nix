{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.resilio;
in {
  options.gab.apps.resilio = {
    enable = lib.mkEnableOption "resilio sync";
    port = lib.mkOption {
      type = lib.types.int;
      default = 8888;
    };
    deviceName = lib.mkOption {
      type  = lib.types.str;
      default = "nixos";
    };
  };

  config = {
    home.packages = lib.optionals cfg.enable [pkgs.resilio-sync];

    home.file = lib.mkIf cfg.enable {
      ".config/resilio-sync/sync.conf".text = ''
        {
          "device_name": "${cfg.deviceName}",
          "listening_port": 0,
          "storage_path": "/home/${config.home.username}/.config/resilio-sync",
          "webui": {
            "listen": "127.0.0.1:${builtins.toString cfg.port}"
          }
        }
      '';
    };

    systemd.user.services = lib.mkIf cfg.enable {
      resilio-sync = let
        start = pkgs.writeShellScriptBin "start-resilio-sync" ''
          cp ~/.config/resilio-sync/sync.conf /tmp/resilio_sync.conf
          ${pkgs.resilio-sync}/bin/rslsync --nodaemon --config /tmp/resilio_sync.conf
        '';
      in {
        Unit = {
          Description = "Resilio Sync User Service";
          After = ["network.target"];
        };
        Service = {
          ExecStart = "${start}/bin/start-resilio-sync";
          Restart = "always";
        };
        Install = {
          WantedBy = ["default.target"];
        };
      };
    };
  };
}
