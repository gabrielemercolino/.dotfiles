{ self, lib, ... }:
{
  hosts.home-server = {
    nixos =
      { config, pkgs, host, user, ... }:
      {
        systemd.tmpfiles.rules = [
          "d /tank/agentmemory 0750 ${user.name} users -"
          "d /tank/agentmemory/data 0750 ${user.name} users -"
        ];

        sops = {
          secrets."agentmemory/secret" = {
            owner = user.name;
            group = "users";
          };
          templates."agentmemory.env" = {
            content = "AGENTMEMORY_SECRET=${config.sops.placeholder."agentmemory/secret"}";
            owner = user.name;
            group = "users";
          };
        };

        systemd.services.agentmemory = {
          description = "agentmemory persistent memory server";
          # agentmemory locates iii-engine (and its auto-installer's tools)
          # via the `which` command, which is not in NixOS's minimal default
          # service PATH. Provide it plus the auto-install fallbacks.
          path = [
            pkgs.which
            pkgs.curl
            pkgs.gnutar
            pkgs.bash
          ];
          after = [
            "network-online.target"
            "zfs-mount.service"
            "sops-install-secrets.service"
          ];
          wants = [ "network-online.target" ];
          requires = [ "zfs-mount.service" ];
          wantedBy = [ "multi-user.target" ];

          serviceConfig = {
            User = user.name;
            Group = "users";
            # Fresh HOME per start: pidfiles/config templates live here and
            # are re-seeded each boot (upstream's supported tmpfs pattern).
            RuntimeDirectory = "agentmemory";
            Environment = [
              "HOME=/run/agentmemory"
              "AGENTMEMORY_DATA_DIR=/tank/agentmemory/data"
              "CI=1"
            ];
            EnvironmentFile = config.sops.templates."agentmemory.env".path;
            ExecStart = "${lib.getExe self.packages.${host.system}.agentmemory} --data-dir /tank/agentmemory/data";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };

        systemd.services.tailscale-serve-agentmemory = {
          description = "Tailscale Serve proxy for agentmemory";
          after = [
            "tailscale-online.target"
            "agentmemory.service"
          ];
          requires = [ "tailscale-online.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe config.services.tailscale.package} serve --https=8443 http://127.0.0.1:3111";
            Restart = "always";
            RestartSec = "5s";
          };
        };
      };
  };
}
