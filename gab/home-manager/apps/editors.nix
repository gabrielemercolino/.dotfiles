{ config, lib, inputs, pkgs, ... }:

let
  cfg = config.gab.apps.editors;
in
{
  config = {
    home.packages = lib.optionals cfg.nvim           [ inputs.nixvim.packages.${pkgs.system}.default ]
                 ++ lib.optionals cfg.idea-community [ pkgs.jetbrains.idea-community-bin ] # bin = latest 🙄
                 ++ lib.optionals cfg.zed-editor     [ pkgs.zed-editor ];
  };
}
