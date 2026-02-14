{
  config,
  lib,
  ...
}: let
  cfg = config.gab.apps.music;
in {
  options.gab.apps.music = {
    mpd.enable = lib.mkEnableOption "mpd";
  };

  config = {
    programs = {
      cava = {
        inherit (cfg.mpd) enable;
        settings = {
          general.framerate = 60;
        };
      };
    };

    services = {
      mpd = {
        inherit (cfg.mpd) enable;
        musicDirectory = "${config.home.homeDirectory}/Music";
        # TODO: fix the audio_output config
        extraConfig = ''
          audio_output {
            type     "fifo"
            name     "my_fifo"
            path     "/tmp/mpd.fifo"
            format   "44100:16:2"
          }

          audio_output {
            type     "pipewire"
            name     "Default Output"
          }
        '';
      };
    };
  };
}
