{ config, lib, ... }:
{
  flake.modules.homeManager = {
    services.imports = [ config.flake.modules.homeManager.resilio ];

    resilio =
      {
        config,
        pkgs,
        host,
        ...
      }:
      let
        cfg = config.gab.services.resilio;
      in
      {
        options.gab.services.resilio = {
          enable = lib.mkEnableOption "resilio sync";
          port = lib.mkOption {
            type = lib.types.int;
            default = 8888;
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [ pkgs.resilio-sync ];

          home.file = {
            ".config/resilio-sync/sync.conf".text = ''
              {
                "device_name": "${host.name}",
                "listening_port": 0,
                "storage_path": "${config.xdg.configHome}/resilio-sync",
                "webui": {
                  "listen": "127.0.0.1:${toString cfg.port}"
                }
              }
            '';
          };

          systemd.user.services = {
            resilio-sync =
              let
                start = pkgs.writeShellScriptBin "start-resilio-sync" ''
                  cp ~/.config/resilio-sync/sync.conf /tmp/resilio_sync.conf
                  ${pkgs.resilio-sync}/bin/rslsync --nodaemon --config /tmp/resilio_sync.conf
                '';
              in
              {
                Unit = {
                  Description = "Resilio Sync User Service";
                  After = [ "network.target" ];
                };
                Service = {
                  ExecStart = "${start}/bin/start-resilio-sync";
                  Restart = "always";
                };
                Install = {
                  WantedBy = [ "default.target" ];
                };
              };
          };
        };
      };
  };
}
