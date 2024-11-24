{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.gab.apps;
in
{
  options.gab.apps = {
    idea-community.enable = lib.mkEnableOption "idea community edition";
    zed-editor.enable = lib.mkEnableOption "zed editor";
    nvim.enable = lib.mkEnableOption "neovim (with nixvim)";
    vscode = {
      enable = lib.mkEnableOption "vsocode";
      extensions = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        example = with pkgs.vscode-extensions; [
          bbenoist.nix
        ];
      };
    };
  };

  config = {
    home.packages =
      lib.optionals cfg.nvim.enable [ inputs.nixvim.packages.${pkgs.system}.default ]
      ++ lib.optionals cfg.idea-community.enable [ pkgs.jetbrains.idea-community-bin ] # bin = latest 🙄
      ++ lib.optionals cfg.zed-editor.enable [ pkgs.zed-editor ];

    programs.vscode = {
      enable = true;
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      mutableExtensionsDir = false;
      userSettings = {
        "editor.fontSize" = 18;
        "editor.tabSize" = 2;
        "extensions.autoUpdate" = false;
      };

      extensions = cfg.vscode.extensions;
    };
  };
}
