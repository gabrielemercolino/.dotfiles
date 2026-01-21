{
  pkgs,
  lib,
  inputs,
  userSettings,
  ...
}: let
  # fix: needed for unfree packages
  firefox-addons = pkgs.callPackage inputs.firefox-addons {
    inherit (pkgs) fetchurl stdenv lib;
  };
in {
  imports = [inputs.zen-browser.homeModules.beta];

  config = {
    programs.zen-browser = {
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
        ];
      };

      policies = import ./policies.nix {inherit lib;};
    };
  };
}
