{ self, lib, ... }:
let
  opacity = 0.7;
  polarity = "dark";

  palette = {
    base00 = "#1a1b26"; # background
    base01 = "#16161e"; # darker background
    base02 = "#2f3549"; # selection background
    base03 = "#444b6a"; # comments, line highlighting
    base04 = "#787c99"; # dark foreground
    base05 = "#a9b1d6"; # default foreground
    base06 = "#cbccd1"; # light foreground
    base07 = "#d5d6db"; # lightest foreground
    base08 = "#f7768e"; # red/pink
    base09 = "#ff9e64"; # orange
    base0A = "#e0af68"; # yellow
    base0B = "#9ece6a"; # green
    base0C = "#73daca"; # cyan/teal
    base0D = "#7aa2f7"; # blue
    base0E = "#bb9af7"; # purple/magenta
    base0F = "#ff007c"; # bright red/pink accent
  };

  inherit (lib) mkForce;
in
{
  nixos =
    { user, pkgs, ... }:
    let
      nixos = self.modules.nixos;
      background = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ChapST1/gruvbox-wallpapers-web/master/wallpapers/mix/17.jpg";
        hash = "sha256-p5Mo1xA4jBZh6PPP0HK2YsuEBkP/gA27YDvxtuUrPHE=";
      };
    in
    {
      imports = with nixos; [ sddm ];

      stylix = {
        base16Scheme = palette;
        image = background;
        polarity = polarity;
        opacity.terminal = opacity;
      };

      programs = {
        silentSDDM =
          let
            imgName = img: if lib.isDerivation img then img.name else builtins.baseNameOf img;
          in
          {
            backgrounds.bg = background;

            settings = {
              "LoginScreen" = {
                blur = 32;
                background = "${imgName background}";
              };
              "LockScreen" = {
                blur = 0;
                background = "${imgName background}";
              };
            };
          };
      };
    };

  home =
    {
      config,
      pkgs,
      host,
      ...
    }:
    let
      home = self.modules.homeManager;
      background = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/ChapST1/gruvbox-wallpapers-web/master/wallpapers/mix/17.jpg";
        hash = "sha256-p5Mo1xA4jBZh6PPP0HK2YsuEBkP/gA27YDvxtuUrPHE=";
      };
    in
    {
      imports = with home; [ hyprland ];

      config = {
        stylix = {
          base16Scheme = palette;
          image = background;
          polarity = polarity;
          opacity.terminal = opacity;
        };

        programs = {
          ags-bar.settings.colors = palette;

          rofi.theme =
            let
              inherit (config.lib.formats.rasi) mkLiteral;
            in
            {
              "*".selected = mkForce (mkLiteral palette.base0F);
            };

          cava.settings = {
            color = {
              gradient = 1;
              gradient_color_1 = mkForce "'${palette.base08}'";
              gradient_color_2 = mkForce "'${palette.base0F}'";
              gradient_color_3 = mkForce "'${palette.base09}'";
              gradient_color_4 = mkForce "'${palette.base0A}'";
            };
          };
        };
      };
    };
}
