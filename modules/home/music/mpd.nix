{ self, lib, ... }:
{
  flake.modules.homeManager = {
    music.imports = [ self.modules.homeManager.mpd ];

    mpd =
      {
        config,
        pkgs,
        audio,
        loadTheme,
        ...
      }:
      let
        cfg = config.gab.music.mpd;
        theme = loadTheme { inherit config lib pkgs; };
        home = theme.home or { };
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
            cava =
              let
                cava = home.cava or { };
              in
              {
                enable = true;
                settings = lib.mkMerge [
                  {
                    general = {
                      framerate = 60;
                      sensitivity = 50;
                      bar_width = 1;
                      bar_spacing = 1;
                    };
                  }
                  (cava.settings or { })
                ];
              };
          };
        };
      };
  };
}
