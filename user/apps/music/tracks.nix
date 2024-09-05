{ config, pkgs, lib, ... }:

let
  defaultTrackDir = "${config.home.homeDirectory}/Music";

  downloadTrack = track:
    let
      url = if builtins.isString track then track else track.url;
      destinationDir = if builtins.isString track then defaultTrackDir else track.destinationDir or defaultTrackDir;
      fileName = if builtins.isString track then "%(title)s" else track.fileName or "%(title)s";
      format = if builtins.isString track then "m4a" else track.format or "m4a";
    in
    ''
      mkdir -p ${destinationDir}
      cd ${destinationDir}
      tempFileName=$(${pkgs.yt-dlp}/bin/yt-dlp --skip-download --get-filename -o "${fileName}.${format}" ${url})
      if [ -f "$tempFileName" ]; then 
        printf "\033[32;1mskipping $tempFileName \033[0m\n"
      else
        printf "\033[33;1mdownloading $tempFileName \033[0m\n"
        ${pkgs.yt-dlp}/bin/yt-dlp --extract-audio --audio-format ${format} --embed-thumbnail --quiet --progress --progress-template "download-title:%(info.id)s-%(progress.eta)s" -o "${fileName}.%(ext)s" ${url}
      fi
    '';

  downloadTracks = videoList: builtins.concatStringsSep "\n" (map (video: downloadTrack video) videoList);

  tracks = [
    {
      url = "https://youtu.be/Jrg9KxGNeJY?si=9_DfB4VwSDHVVBL8";
      fileName = "Bury the light";
    }
    {
      url = "https://youtu.be/qKn2lPyAyqQ";
      fileName = "Bury the light - rock";
    }
  ];

in
{
  home.activation.downloadTracks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${downloadTracks tracks}
  '';
}
