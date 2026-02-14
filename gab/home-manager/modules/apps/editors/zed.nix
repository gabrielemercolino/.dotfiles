{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.zed-editor;
in {
  options.gab.apps.zed-editor = {
    enable = lib.mkEnableOption "zed editor";
  };

  config = {
    programs.zed-editor = {
      inherit (cfg) enable;
    };
  };
}
