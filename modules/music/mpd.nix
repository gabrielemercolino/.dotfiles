{
  self,
  lib,
  ...
}:
with lib.types; {
  flake.homeModules.mpd = {config, ...}: let
    cfg = config.gab.music.mpd;
  in {
    options.gab.music.mpd = {
      enable = lib.mkEnableOption "mpd";
      musicDirectory = lib.mkOption {
        type = str;
        default = "${config.home.homeDirectory}/Music";
      };
    };

    config = lib.mkIf cfg.enable {
      programs = {
        cava = {
          enable = lib.mkDefault true;
          settings = {
            general.framerate = 60;
          };
        };
      };

      services = {
        mpd = {
          enable = true;

          musicDirectory = cfg.musicDirectory;
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
  };

  flake.homeModules.music = _: {imports = [self.homeModules.mpd];};
}
