{ inputs, ... }:
{
  hosts.home-server = {
    nixos =
      {
        config,
        pkgs,
        host,
        ...
      }:
      {
        imports = [ inputs.hermes-agent.nixosModules.default ];

        services.hermes-agent = {
          enable = true;

          package = inputs.hermes-agent.packages.${host.system}.minimal;

          user = "hermes";
          group = "hermes";
          addToSystemPackages = true;
          container.hostUsers = [ "gabriele" ];
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

            webapp = {
              enabled = true;
              host = "127.0.0.1";
              port = 9119;
              public_url = "https://hermes.ciruzzo.win";
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
              "--pids-limit=1024"
              "--memory=8g"
              "--cpus=4"
            ];
          };
        };

        systemd.services.hermes-agent.unitConfig.RequiresMountsFor = [ "/tank/hermes" ];

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
