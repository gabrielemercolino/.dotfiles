{
  lib,
  config,
  ...
}: let
  cfg = config.gab.apps.zoxide;
in {
  options.gab.apps.zoxide = {
    enable = lib.mkEnableOption "zoxide (smarter cd)";
  };

  config = {
    programs.zoxide = {
      inherit (cfg) enable;

      enableBashIntegration = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
    };
  };
}
