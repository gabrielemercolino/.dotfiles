{
  config,
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: let
  cfg = config.gab.apps.zen;
  # fix: needed for unfree packages
  firefox-addons = pkgs.callPackage inputs.firefox-addons {
    inherit (pkgs) fetchurl stdenv lib;
  };
in {
  imports = [inputs.zen-browser.homeModules.beta];

  options.gab.apps.zen = {
    enable = lib.mkEnableOption "zen";
  };

  config = {
    programs.zen-browser = {
      inherit (cfg) enable;
      profiles.${userSettings.userName} = {
        isDefault = true;

        extensions.packages = with firefox-addons; [
          # essentials
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
}
