{ lib, ... }:
{
  flake.modules.homeManager = {
    pi =
      { config, pkgs, ... }:
      let
        cfg = config.gab.cli.pi;
      in
      {
        config = lib.mkIf cfg.enable {
          sops.secrets."searxng/key" = { };

          xdg.configFile."searxng/settings.yml".text = ''
            use_default_settings: true
            server:
              bind_address: "127.0.0.1"
              port: 18080
            search:
              formats:
                - html
                - json
            engines:
              keep_only:
                - duckduckgo
                - wikipedia
                - github
                - stackoverflow
          '';

          systemd.user.services.searx = {
            Unit = {
              Description = "SearXNG metasearch engine";
              After = [ "network.target" ];
            };
            Service = {
              Type = "simple";
              ExecStartPre = "${pkgs.writeShellScript "searx-prepare-env" ''
                printf 'SEARXNG_SECRET=%s\n' "$(${pkgs.coreutils}/bin/cat ${
                  config.sops.secrets."searxng/key".path
                })" > "$XDG_RUNTIME_DIR/searxng-env"
              ''}";
              EnvironmentFile = "-%t/searxng-env";
              Environment = "SEARXNG_SETTINGS_PATH=${config.xdg.configHome}/searxng/settings.yml";
              ExecStart = "${pkgs.searxng}/bin/searxng-run";
              Restart = "on-failure";
              RestartSec = "5s";
            };
            Install = {
              WantedBy = [ "default.target" ];
            };
          };
        };
      };
  };
}
