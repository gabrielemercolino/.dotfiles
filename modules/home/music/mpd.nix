{ self, lib, ... }:
{
  flake.modules.homeManager = {
    music.imports = [ self.modules.homeManager.mpd ];

    mpd =
      {
        config,
        pkgs,
        audio,
        ...
      }:
      let
        cfg = config.gab.music.mpd;
      in
      {
        options.gab.music.mpd = {
          enable = lib.mkEnableOption "mpd";
        };

        config = lib.mkIf cfg.enable {
          services = {
            mpd = {
              enable = true;
              musicDirectory = "${config.home.homeDirectory}/Music";
              extraConfig = ''
                audio_output {
                  type     "fifo"
                  name     "my_fifo"
                  path     "/tmp/mpd.fifo"
                  format   "44100:16:2"
                }
              ''
              + lib.optionalString (audio == "pipewire") ''
                audio_output {
                  type     "pipewire"
                  name     "Pipewire Output"
                }
              '';
            };
          };

          programs = {
            cava = {
              enable = true;
              settings = {
                general = {
                  framerate = 60;
                  sensitivity = 50;
                  bar_width = 1;
                  bar_spacing = 1;
                };
              };
            };
          };
        };
      };
  };
}
