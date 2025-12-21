{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  imports = [inputs.nvf.homeManagerModules.default ./configs/helix.nix];

  options.gab.apps = {
    idea-community.enable = lib.mkEnableOption "idea community edition";
    zed-editor.enable = lib.mkEnableOption "zed editor";
    nixvim.enable = lib.mkEnableOption "neovim (with nixvim)";
    nvf.enable = lib.mkEnableOption "neovim (with nvf)";
    helix.enable = lib.mkEnableOption "helix";
  };

  config = {
    home.packages =
      lib.optionals cfg.nixvim.enable [inputs.nixvim.packages.${pkgs.stdenv.hostPlatform.system}.default]
      ++ lib.optionals cfg.idea-community.enable [pkgs.jetbrains.idea-oss]
      ++ lib.optionals cfg.zed-editor.enable [pkgs.zed-editor];

    programs.nvf.enable = (cfg.nvf).enable;
    programs.helix.enable = cfg.helix.enable;
  };
}
