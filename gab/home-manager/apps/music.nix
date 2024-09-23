{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.gab.apps.music;

  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  downloadMusic = music: 
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

  config = {
    home.activation.downloadTracks = lib.hm.dag.entryAfter ["writeBoundary"] ''
      ${downloadMusics cfg.tracks}
    '';

    programs.spicetify = {
      enable = cfg.spotify;

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle # shuffle+ (special characters are sanitized out of extension names)
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };

}
