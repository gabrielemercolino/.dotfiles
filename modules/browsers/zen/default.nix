{
  self,
  inputs,
  lib,
  ...
}: {
  flake.homeModules.browsers = {
    config,
    pkgs,
    ...
  }: let
    cfg = config.gab.browsers.zen;
    # fix: needed for unfree packages
    firefox-addons = pkgs.callPackage inputs.firefox-addons {
      inherit (pkgs) fetchurl stdenv lib;
    };
  in {
    imports = [inputs.zen-browser.homeModules.beta self.homeModules.user];

    options.gab.browsers.zen = {
      enable = lib.mkEnableOption "zen";
    };

    config = lib.mkIf cfg.enable {
      programs.zen-browser = {
        enable = true;

        profiles.${config.gab.user.name} = {
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

        policies = import ./_policies.nix {inherit lib;};
      };
    };
  };
}
