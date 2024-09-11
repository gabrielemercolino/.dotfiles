{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.gab.editors;
in
{
  options.gab.editors = {
    nvim = lib.mkOption {
      default = true;
      description = "Whether to enable nvim";
    };
    intellij = lib.mkEnableOption "intellij";
    zed = lib.mkEnableOption "zed-editor";
  };

  config = {
    home.packages = lib.optionals cfg.nvim     [ inputs.nixvim.packages.${pkgs.system}.default ]
                 ++ lib.optionals cfg.intellij [ pkgs.jetbrains.idea-community-bin ] # bin = latest 🙄
                 ++ lib.optionals cfg.zed      [ pkgs.zed-editor ];
  };
}
