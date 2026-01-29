{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps;
in {
  imports = [./configs/helix.nix];

  options.gab.apps = {
    idea-community.enable = lib.mkEnableOption "idea community edition";
    zed-editor.enable = lib.mkEnableOption "zed editor";
    helix.enable = lib.mkEnableOption "helix";
  };

  config = {
    home.packages = lib.optionals cfg.idea-community.enable [(pkgs.callPackage ./custom-derivations/idea.nix {})];

    programs = {
      helix.enable = cfg.helix.enable;
      zed-editor = {
        inherit (cfg.zed-editor) enable;
      };
    };
  };
}
