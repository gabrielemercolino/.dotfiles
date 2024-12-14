{
  config,
  lib,
  ...
}:

let
  cfg = config.gab.wm.bspwm;
in
{
  options.gab.wm.bspwm = {
    enable = lib.mkEnableOption "bspwm";
  };

  config = lib.mkIf cfg.enable {
    xsession.windowManager.bspwm = {
      enable = true;
    };
  };

}
