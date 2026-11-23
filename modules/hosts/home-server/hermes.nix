{
  hosts.home-server = {
    nixos =
      {
        config,
        pkgs,
        ...
      }:
      let
        dataDir = "/tank/hermes";

        configYaml = pkgs.writeText "hermes-config.yaml" (
          builtins.toJSON {
            model = {
              provider = "deepseek";
              default = "deepseek-flash";
            };

            agent.reasoning_effort = "high";

            dashboard = {
              public_url = "https://hermes.ciruzzo.win";
              basic_auth.username = "admin";
            };
          }
        );
      in
      {
        systemd.tmpfiles.rules = [ "d ${dataDir} 0700 root root -" ];

        sops = {
          secrets = {
            "deepseek/key" = { };
            "hermes/password" = { };
            "hermes/secret" = { };
          };

          templates."hermes.env".content = ''
            DEEPSEEK_API_KEY=${config.sops.placeholder."deepseek/key"}
            HERMES_DASHBOARD_BASIC_AUTH_USERNAME=admin
            HERMES_DASHBOARD_BASIC_AUTH_PASSWORD=${config.sops.placeholder."hermes/password"}
            HERMES_DASHBOARD_BASIC_AUTH_SECRET=${config.sops.placeholder."hermes/secret"}
          '';
        };

        virtualisation.oci-containers = {
          backend = "docker";

          containers.hermes = {
            image = "nousresearch/hermes-agent:v0.23.3";
            cmd = [
              "gateway"
              "run"
            ];

            environment = {
              HERMES_DASHBOARD = "1";
              HERMES_DASHBOARD_HOST = "127.0.0.1";
              HERMES_DASHBOARD_PORT = "9119";
            };

            environmentFiles = [ config.sops.templates."hermes.env".path ];

            volumes = [
              "${dataDir}:/opt/data"
              "${configYaml}:/opt/data/config.yaml:ro"
            ];

            extraOptions = [ "--network=host" ];
          };
        };

        systemd.services.docker-hermes = {
          after = [ "sops-install-secrets.service" ];
          wants = [ "sops-install-secrets.service" ];
          unitConfig.RequiresMountsFor = [ dataDir ];
        };
      };
  };
}
