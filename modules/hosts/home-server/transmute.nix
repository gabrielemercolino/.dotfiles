{ ... }:
{
  hosts.home-server = {
    nixos = { config, ... }: {
      systemd.tmpfiles.rules = [ "d /tank/transmute 0755 root root -" ];

      sops = {
        secrets."transmute/auth/key" = { };
        templates."transmute.env".content = ''
          AUTH_SECRET_KEY=${config.sops.placeholder."transmute/auth/key"}
        '';
      };

      virtualisation.oci-containers = {
        backend = "docker";
        containers.transmute = {
          image = "ghcr.io/transmute-app/transmute:latest";
          pull = "always";
          ports = [ "127.0.0.1:3313:3313" ];
          volumes = [ "/tank/transmute:/app/data" ];
          environment = {
            ALLOW_UNAUTHENTICATED = "false";
            CONVERSION_WORKER_CONCURRENCY = "2";
            # 90 MiB: chunk uploads to stay under Cloudflare's 100 MB request-body limit
            MAX_CHUNK_SIZE = "94371840";
          };
          environmentFiles = [ config.sops.templates."transmute.env".path ];
        };
      };

      systemd.services.docker-transmute = {
        unitConfig.RequiresMountsFor = [ "/tank/transmute" ];
      };
    };
  };
}
