{ self, lib, ... }:
{
  flake.modules.homeManager = {
    services.imports = [ self.modules.homeManager.hypridle ];

    hypridle =
      { config, ... }:
      let
        cfg = config.gab.services.hypridle;

        # TODO: remove/clean this
        # Both WMs can be enabled on a host; detect which compositor is running.
        dpmsOff = ''if pgrep -x Hyprland >/dev/null; then hyprctl dispatch 'hl.dsp.dpms({ action = "disable" })'; else umbriel msg dpms-off; fi'';
        dpmsOn = ''if pgrep -x Hyprland >/dev/null; then hyprctl dispatch 'hl.dsp.dpms({ action = "enable" })'; else umbriel msg dpms-on; fi'';
      in
      {
        options.gab.services.hypridle = {
          enable = lib.mkEnableOption "hypridle";
        };

        config = lib.mkIf cfg.enable {
          services.hypridle = {
            enable = true;
            settings = {
              general = {
                lock_cmd = "pidof hyprlock || hyprlock";
                before_sleep_cmd = "loginctl lock-session";
                after_sleep_cmd = dpmsOn;
              };

              listener = [
                {
                  timeout = 5 * 60;
                  on-timeout = "loginctl lock-session";
                }
                {
                  timeout = 10 * 60;
                  on-timeout = dpmsOff;
                  on-resume = dpmsOn;
                }
                {
                  timeout = 30 * 60;
                  on-timeout = "systemctl suspend";
                }
              ];
            };
          };
        };
      };
  };
}
