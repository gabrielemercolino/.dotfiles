{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  imports = [inputs.nvf.homeManagerModules.default];

  options.gab.apps = {
    idea-community.enable = lib.mkEnableOption "idea community edition";
    zed-editor.enable = lib.mkEnableOption "zed editor";
    nixvim.enable = lib.mkEnableOption "neovim (with nixvim)";
    nvf.enable = lib.mkEnableOption "neovim (with nvf)";
  };

  config = {
    home.packages =
      lib.optionals cfg.nixvim.enable [inputs.nixvim.packages.${pkgs.system}.default]
      ++ lib.optionals cfg.idea-community.enable [pkgs.jetbrains.idea-community-bin] # bin = latest 🙄
      ++ lib.optionals cfg.zed-editor.enable [pkgs.zed-editor];

    programs.nvf = {
      inherit (cfg.nvf) enable;
    };
  };
}
