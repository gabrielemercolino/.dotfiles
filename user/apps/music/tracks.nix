{ config, pkgs, lib, ... }:

let
  defaultDestinationDir = "${config.home.homeDirectory}/Music";

  downloadSingleVideo = video:
    let
      url = if builtins.isString video then video else video.url;
      destinationDir = if builtins.isString video then defaultDestinationDir else video.destinationDir or defaultDestinationDir;
      fileName = if builtins.isString video then "%(title)s" else video.fileName or "%(title)s";   
    in
    ''
      mkdir -p ${destinationDir}
      cd ${destinationDir}
      tempFileName=$(${pkgs.yt-dlp}/bin/yt-dlp --skip-download --get-filename -o "${fileName}" ${url})
      [ -f "$tempFileName" ] || ${pkgs.yt-dlp}/bin/yt-dlp --extract-audio --audio-format m4a --embed-thumbnail -o "${fileName}.m4a" ${url}
    '';

  downloadYoutubeVideos = videoList: builtins.concatStringsSep "\n" (map (video: downloadSingleVideo video) videoList);

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
  home.activation.downloadYoutubeVideos = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${downloadYoutubeVideos tracks}
  '';
}
