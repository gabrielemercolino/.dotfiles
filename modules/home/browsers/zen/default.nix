{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.homeManager = {
    browsers.imports = [ self.modules.homeManager.zen ];

    zen =
      {
        config,
        pkgs,
        user,
        ...
      }:
      let
        cfg = config.gab.browsers.zen;
        # fix: needed for unfree packages
        firefox-addons = pkgs.callPackage inputs.firefox-addons {
          inherit (pkgs) fetchurl stdenv lib;
        };
      in
      {
        imports = [ inputs.zen-browser.homeModules.beta ];

        options.gab.browsers.zen = {
          enable = lib.mkEnableOption "zen";
        };

        config = lib.mkIf cfg.enable {
          programs.zen-browser = {
            enable = true;

            profiles.${user.name} = {
              isDefault = true;

              extensions.packages = with firefox-addons; [
                bitwarden
                ublock-origin
                tampermonkey
                darkreader
                cookies-txt
                youtube-recommended-videos
                indie-wiki-buddy
              ];
            };
          };
        };
      };
  };
}
