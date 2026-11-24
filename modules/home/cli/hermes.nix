{ self, lib, ... }:
{
  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.hermes ];

    hermes =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.hermes;

        remote = pkgs.writeText "hermes-remote" ''
          set -eu

          mode="''${HERMES_HOME:-$HOME/.hermes}/.container-mode"
          if [ ! -r "$mode" ]; then
            echo "hermes: container mode is off on $(uname -n); running the local binary" >&2
            exec hermes "$@"
          fi

          . "$mode"

          exec docker exec -it -u "''${exec_user:-hermes}" \
            -e "TERM=''${TERM:-xterm}" \
            "''${container_name:-hermes-agent}" \
            "''${hermes_bin:-/data/current-package/bin/hermes}" "$@"
        '';
      in
      {
        options.gab.cli.hermes = {
          enable = lib.mkEnableOption "hermes CLI, tunnelled over ssh into the container on the host running the service";

          host = lib.mkOption {
            type = lib.types.str;
            default = "home-server";
            description = "SSH target that has the hermes service.";
          };
        };

        config = lib.mkIf cfg.enable {
          home.packages = [
            (pkgs.writeShellApplication {
              name = "hermes";
              runtimeInputs = [ pkgs.openssh ];
              text = ''
                # shellcheck disable=SC2016
                remote=${lib.escapeShellArg (builtins.readFile remote)}

                args=""
                for arg in "$@"; do
                  args="$args $(printf '%q' "$arg")"
                done

                exec ssh -t ${lib.escapeShellArg cfg.host} "$remote $args"
              '';
            })
          ];
        };
      };
  };
}
