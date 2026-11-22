{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos = {
    hm.imports = [ self.modules.nixos.dsh-hm ];

    dsh-hm = {
      nixpkgs.overlays = [ inputs.deepseek-harness.overlays.default ];
    };
  };

  flake.modules.homeManager = {
    cli.imports = [ self.modules.homeManager.dsh ];

    dsh =
      {
        config,
        pkgs,
        host,
        ...
      }:
      let
        cfg = config.gab.cli.dsh;
      in
      {
        imports = [ inputs.deepseek-harness.homeModules.default ];

        options.gab.cli.dsh = {
          enable = lib.mkEnableOption "DeepSeek Harness (dsh)";
        };

        config = lib.mkIf cfg.enable {
          programs.dsh = {
            enable = true;

            package = inputs.deepseek-harness.packages.${host.system}.dsh;
            defaultProfile = config.programs.dsh.profiles.tui.materializedName;
          };

          sops.secrets."deepseek/key" = { };

          sops.templates."dsh/.env" = {
            path = "${config.home.homeDirectory}/.dsh/.env";
            content = "DEEPSEEK_API_KEY=${config.sops.placeholder."deepseek/key"}\n";
          };

          home.file = {
            ".dsh/AGENTS.md".source = ../pi/APPEND_SYSTEM.md;

            ".dsh/skills/versioning-preferences".source = ../pi/skills/versioning-preferences;
          };
        };
      };
  };
}
