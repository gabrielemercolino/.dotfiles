{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.gab.apps.music;

  downloadMusic = music: let
    url = music.url;
    fileName = music.fileName;
    directory = music.directory;
    format = music.format;
  in ''
    mkdir -p ${directory}
    cd ${directory}
    if [ -f "${fileName}.${format}" ]; then
      printf "\033[32;1mskipping ${fileName} \033[0m\n"
    else
      audio_flags="--extract-audio --audio-format ${format}"
      progress_flags="--progress --progress-template \"download-title:%(info.id)s-%(progress.eta)s\""
      printf "\033[33;1mdownloading ${fileName} \033[0m\n"
      ${lib.getExe pkgs.yt-dlp} $audio_flags --embed-thumbnail --quiet $progress_flags -o "${fileName}.${format}" ${url}
    fi
  '';

  downloadMusics = musics: ''
    ${musics |> map downloadMusic |> lib.concatStringsSep "\n"}
  '';
in {
  options.gab.apps.music = {
    tracks = lib.mkOption {
      type = with lib.types;
        listOf (submodule {
          options = {
            url = lib.mkOption {type = str;};
            fileName = lib.mkOption {
              type = str;
              default = "%(title)s";
            };
            format = lib.mkOption {
              type = enum [
                "m4a"
                "mp3"
              ];
              default = "m4a";
            };
            directory = lib.mkOption {
              type = str;
              default = "${config.home.homeDirectory}/Music";
            };
          };
        });

      description = ''
        List of tracks to download. To be able to download a track its url must be compatible with yt-dlp.
        The elements are set that must contain the url and optionally
        the path to the destination directory, the filename and the format.
      '';

      example = [
        {url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY";}
        {
          url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY";
          path = "${config.home.homeDirectory}/some/other/dir";
          fileName = "Definitely not Bury the Light";
          format = "mp3";
        }
      ];

      default = [];
    };

    mpd.enable = lib.mkEnableOption "mpd";
    rmpc.enable = lib.mkEnableOption "rmpc";
  };

  config = {
    home.activation.downloadTracks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${downloadMusics cfg.tracks}
    '';

    programs = {
      cava = {inherit (cfg.rmpc) enable;};
      rmpc = {
        inherit (cfg.rmpc) enable;
        config = import ./configs/rmpc.nix {inherit config;};
      };
    };

    services = {
      mpd = {
        inherit (cfg.mpd) enable;
        musicDirectory = "${config.home.homeDirectory}/Music";
      };
    };
  };
}
