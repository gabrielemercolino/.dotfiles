{
  config,
  lib,
  pkgs,
  systemSettings,
  ...
}: let
  cfg = config.gab.apps;
in {
  options.gab.apps = {
    yazi.enable = lib.mkEnableOption "yazi";
    gimp.enable = lib.mkEnableOption "gimp";
    obsidian.enable = lib.mkEnableOption "obsidian";
    swaylock.enable = lib.mkEnableOption "swaylock";
    aseprite.enable = lib.mkEnableOption "aseprite";
    tiled.enable = lib.mkEnableOption "tiled";
    resilio = {
      enable = lib.mkEnableOption "resilio sync";
      port = lib.mkOption {
        type = lib.types.int;
        default = 8888;
      };
    };
    rofi.enable = lib.mkEnableOption "rofi";
  };

  config = {
    home.packages =
      lib.optionals cfg.gimp.enable [pkgs.gimp]
      ++ lib.optionals cfg.obsidian.enable [pkgs.obsidian]
      ++ lib.optionals cfg.aseprite.enable [pkgs.aseprite]
      ++ lib.optionals cfg.tiled.enable [pkgs.tiled]
      ++ lib.optionals cfg.resilio.enable [pkgs.resilio-sync];

    programs = {
      yazi = {
        inherit (cfg.yazi) enable;
        settings = {
          manager = {
            show_hidden = true;
          };
        };
      };

      swaylock = {
        inherit (cfg.swaylock) enable;
        package = pkgs.swaylock-effects;
      };

      rofi = {
        inherit (cfg.rofi) enable;
        package = pkgs.rofi;
        extraConfig = {
          modi = "drun";
          show-icons = true;
          icon-theme = "WhiteSur";
          display-drun = "run";
          drun-display-format = "{name}";
        };
      };
    };

    home.file = lib.mkIf cfg.resilio.enable {
      ".config/resilio-sync/sync.conf".text = ''
        {
          "device_name": "${systemSettings.hostName}",
          "listening_port": 0,
          "storage_path": "/home/${config.home.username}/.config/resilio-sync",
          "webui": {
            "listen": "127.0.0.1:${builtins.toString cfg.resilio.port}"
          }
        }
      '';
    };

    systemd.user.services = lib.mkIf cfg.resilio.enable {
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
