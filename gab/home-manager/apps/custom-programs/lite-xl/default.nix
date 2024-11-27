{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gab.apps.lite-xl;

  extensions = pkgs.callPackage ./extensions { };

  lspServers = pkgs.callPackage ./lsp-servers { };

  generateExtensions =
    exts:
    builtins.foldl' (
      acc: ext:
      let
        key = ext.passthru.targetDir;
      in
      acc
      // {
        ${key} = {
          source = "${ext}/share/${ext.name}";
          recursive = true;
        };
      }
    ) { } exts;

  #xdg.configFile."lite-xl/libraries/widget" = {
  #  source = "${extensions.widgets}/share/lite-xl-widgets";
  #  recursive = true;
  #};

  generateLspServers =
    servers:
    builtins.foldl' (
      acc: lspServer:
      let
        key = "lite-xl/plugins/${lspServer.name}_lsp.lua";
      in
      acc
      // {
        ${key} = {
          source = "${lspServer}/share/${lspServer.name}_lsp.lua";
        };
      }
    ) { } servers;
in
{
  options.gab.apps.lite-xl = {
    enable = lib.mkEnableOption "lite-xl";
    extensions = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      example = with config.gab.lite-xl-extensions; [
        lsp
        widgets
      ];
      description = "The extensions to add";
    };
    lsp = lib.mkOption {
      type = with lib.types; listOf package;
      default = [];
      example = with config.gab.lite-xl-lsp; [ rust_analyzer ];
      description = "The lsp servers to add";
    };
  };

  options.gab.lite-xl-extensions = lib.mkOption {
    type = with lib.types; attrsOf package;
    default = extensions;
    readOnly = true;
  };

  options.gab.lite-xl-lsp = lib.mkOption {
    type = with lib.types; attrsOf package;
    default = lspServers;
    readOnly = true;
  };

  config = lib.mkIf cfg.enable {

    home.packages = [ pkgs.lite-xl ];

    xdg.configFile = lib.mkMerge [
      (generateExtensions cfg.extensions)
      (generateLspServers cfg.lsp)
    ];

  };

}
