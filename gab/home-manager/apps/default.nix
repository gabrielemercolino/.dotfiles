{ config, lib, ... }:

# Only definitions in this file

{
  imports = [
    ./browsers.nix
    ./control.nix
    ./dev.nix
    ./editors.nix
    ./music.nix
    ./socials.nix
    ./terminal.nix
    ./utilities.nix
  ];

  options.gab.apps = {
    browsers = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          chrome  = lib.mkEnableOption "google chrome";
          firefox = lib.mkEnableOption "firefox";
        };
      };
    };

    control = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          blueman-applet = lib.mkEnableOption "blueman applet";
        };
      };
    };

    dev = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          git = lib.mkOption {
            type = submodule {
              options = {
                enable    = lib.mkEnableOption "git";
                userName  = lib.mkOption { type = nullOr str; default = null; };
                userEmail = lib.mkOption { type = nullOr str; default = null; };
              };
            };
          };
        };
      };
    };

    editors = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          idea-community = lib.mkEnableOption "idea community edition";
          zed-editor     = lib.mkEnableOption "zed editor";
          nvim           = lib.mkEnableOption "neovim (with nixvim)";
        };
      };
    };

    socials = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          telegram = lib.mkEnableOption "telegram desktop";
          discord  = lib.mkEnableOption "discord";
        };
      };
    };

    music = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          tracks = lib.mkOption {
            type = with lib.types; listOf (submodule {
              options = {
                url       = lib.mkOption { type = str; };
                fileName  = lib.mkOption { type = str; default = "%(title)s";};
                format    = lib.mkOption { type = enum [ "m4a" "mp3" ]; default = "m4a";};
                directory = lib.mkOption { type = str; default = "${config.home.homeDirectory}/Music";};
              };
            });
            
            description = ''
              List of tracks to download. To be able to download a track its url must be compatible with yt-dlp.
              The elements are set that must contain the url and optionally
              the path to the destination directory, the filename and the format.
            '';
            
            example = [
              { url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY"; }
              { url = "https://www.youtube.com/watch?v=Jrg9KxGNeJY"; path = "${config.home.homeDirectory}/some/other/dir"; fileName = "Definitely not Bury the Light"; format = "mp3"; }
            ];

            default = [];
          };
          spotify = lib.mkEnableOption "spotify (with spicetify)";
        };
      };
      default = {};
    };

    utilities = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          yazi = lib.mkEnableOption "yazi";
          gimp = lib.mkEnableOption "gimp";
          
          rofi         = lib.mkEnableOption "rofi";
          rofi-wayland = lib.mkEnableOption "rofy for wayland";
        };
      };
    };

    terminal = lib.mkOption {
      type = with lib.types; submodule {
        options = {
          kitty     = lib.mkEnableOption "kitty";
          alacritty = lib.mkEnableOption "alacritty";
          warp      = lib.mkEnableOption "warp";
        };
      };
    };
  };
}
