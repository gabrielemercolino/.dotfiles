{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.gab.apps.music;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  downloadMusic =
    music:
    let
      url = music.url;
      fileName = music.fileName;
      directory = music.directory;
      format = music.format;
    in
    ''
      mkdir -p ${directory}
      cd ${directory}
      if [ -f "${fileName}.${format}" ]; then 
        printf "\033[32;1mskipping ${fileName} \033[0m\n"
      else
        printf "\033[33;1mdownloading ${fileName} \033[0m\n"
        ${pkgs.yt-dlp}/bin/yt-dlp --extract-audio --audio-format ${format} --embed-thumbnail --quiet --progress --progress-template "download-title:%(info.id)s-%(progress.eta)s" -o "${fileName}.${format}" ${url}
      fi
    '';

  downloadMusics = musics: ''
    echo "Downloading tracks..."

    ${lib.concatStringsSep "\n" (map downloadMusic musics)}

    echo "All tracks downloaded."
  '';

in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  options.gab.apps.music = {
    tracks = lib.mkOption {
      type =
        with lib.types;
        listOf (submodule {
          options = {
            url = lib.mkOption { type = str; };
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
        { url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY"; }
        {
          url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY";
          path = "${config.home.homeDirectory}/some/other/dir";
          fileName = "Definitely not Bury the Light";
          format = "mp3";
        }
      ];

      default = [ ];
    };

    spotify.enable = lib.mkEnableOption "spotify (with spicetify)";
  };

  config = {
    home.activation.downloadTracks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${downloadMusics cfg.tracks}
    '';

    programs.spicetify = {
      enable = cfg.spotify.enable;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];
    };
  };

}
