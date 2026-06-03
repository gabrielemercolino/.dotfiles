{ self, lib, ... }:
let
  polarity = "dark";
  background = ./background.png;

  palette = {
    base00 = "#1e1e2e"; # base
    base01 = "#181825"; # mantle
    base02 = "#313244"; # surface0
    base03 = "#45475a"; # surface1
    base04 = "#585b70"; # surface2
    base05 = "#cdd6f4"; # text
    base06 = "#f5e0dc"; # rosewater
    base07 = "#b4befe"; # lavender
    base08 = "#f38ba8"; # red
    base09 = "#fab387"; # peach
    base0A = "#f9e2af"; # yellow
    base0B = "#a6e3a1"; # green
    base0C = "#94e2d5"; # teal
    base0D = "#89b4fa"; # blue
    base0E = "#cba6f7"; # mauve
    base0F = "#f2cdcd"; # flamingo
  };

  inherit (lib) mkForce;
in
{
  nixos =
    { user, pkgs, ... }:
    let
      nixos = self.modules.nixos;
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
          ags-bar.colors.base16 = palette;

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
