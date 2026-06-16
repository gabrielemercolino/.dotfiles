{ self, lib, ... }:
let
  polarity = "dark";

  palette = {
    base00 = "#282828"; # bg (background)
    base01 = "#1d2021"; # bg0_h (hard background)
    base02 = "#3c3836"; # bg1
    base03 = "#504945"; # bg2
    base04 = "#665c54"; # bg3
    base05 = "#ebdbb2"; # fg (foreground/text)
    base06 = "#d5c4a1"; # fg2
    base07 = "#fbf1c7"; # fg0 (light foreground)
    base08 = "#fb4934"; # red (bright red)
    base09 = "#fe8019"; # orange (bright orange)
    base0A = "#fabd2f"; # yellow (bright yellow)
    base0B = "#b8bb26"; # green (bright green)
    base0C = "#8ec07c"; # aqua (bright aqua/teal)
    base0D = "#83a598"; # blue (bright blue)
    base0E = "#d3869b"; # purple (bright purple)
    base0F = "#d65d0e"; # orange alternate (per flamingo)
  };

  inherit (lib) mkForce;
in
{
  nixos =
    { user, pkgs, ... }:
    let
      nixos = self.modules.nixos;
      background = pkgs.fetchurl {
        url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/solar-system-minimal.png";
        hash = "sha256-wDJxF4amPaYiwEl80K9ff5dlHoab2rDjbjHAQS1s6sk=";
      };
    in
    {
      imports = with nixos; [ sddm ];

      stylix = {
        base16Scheme = palette;
        image = background;
        polarity = polarity;
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
        url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/solar-system-minimal.png";
        hash = "sha256-wDJxF4amPaYiwEl80K9ff5dlHoab2rDjbjHAQS1s6sk=";
      };
    in
    {
      imports = with home; [ hyprland ];

      config = {
        stylix = {
          base16Scheme = palette;
          image = background;
          polarity = polarity;
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
