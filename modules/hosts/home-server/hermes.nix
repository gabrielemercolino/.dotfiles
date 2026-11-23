{ inputs, ... }:
{
  hosts.home-server = {
    nixos =
      {
        config,
        pkgs,
        ...
      }:
      {
        imports = [ inputs.hermes-agent.nixosModules.default ];

        services.hermes-agent = {
          enable = true;

          user = "hermes";
          group = "hermes";
          stateDir = "/tank/hermes";

          settings = {
            model = {
              provider = "deepseek";
              default = "deepseek-flash";
            };

            agent = {
              reasoning_effort = "high";
              disabled_toolsets = [
                "kanban"
                "computer_use"
                "cronjob"
                "tts"
                "image_gen"
                "connections"
              ];
            };

            dashboard = {
              public_url = "https://hermes.ciruzzo.win";
              basic_auth.username = "admin";
            };
          };

          mcpServers.rea = {
            command = "npx";
            args = [
              "-y"
              "rea-agents@6.10.1"
              "--mcp"
            ];
            timeout = 300;
            connect_timeout = 120;
            tools.include = [
              "open_binary"
              "binary_session"
              "binary_overview"
              "list_procedures"
              "analyze_function"
              "procedure_pseudo_code"
              "procedure_assembly"
              "xrefs"
              "search_strings"
              "list_strings"
              "search_bytes"
              "trace_feature"
              "inspect_with_objdump"
              "execute_rizin_command"
              "analyze_web_bundle"
              "inspect_web_page"
              "inspect_android_package"
            ];
          };

          environment = {
            HERMES_DASHBOARD = "1";
            HERMES_DASHBOARD_HOST = "127.0.0.1";
            HERMES_DASHBOARD_PORT = "9119";
          };

          environmentFiles = [ config.sops.templates."hermes.env".path ];

          container = {
            enable = true;
            backend = "docker";
            image = "ubuntu:24.04";
            extraOptions = [
              "--network=host"
              "--security-opt=no-new-privileges"
              "--pids-limit=1024"
              "--memory=8g"
              "--cpus=4"
            ];
          };
        };

        # ── Secrets (invariati) ──────────────────────────────────────────
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
      };
  };
}
