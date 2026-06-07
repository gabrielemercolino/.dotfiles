{ self, lib, ... }:
let
  polarity = "dark";
  opacity = 0.8;

  profile = ./profile.webp;
  background = ./background.webp;

  palette = {
    base00 = "#020d05"; # bg - nero con velatura verde profonda
    base01 = "#040f07"; # bg1 - quasi nero, verde percepibile
    base02 = "#0a1f0e"; # bg2 - verde scuro
    base03 = "#142a18"; # bg3 - verde medio
    base04 = "#1e3a22"; # bg4 - verde più esposto
    base05 = "#d8e8c8"; # fg - bianco-verde pallido
    base06 = "#bcd0a8"; # fg1 - verde chiaro desaturato
    base07 = "#eaf5e0"; # fg2 - quasi bianco con velo verde
    base08 = "#d92b2b"; # red (errori)
    base09 = "#38c050"; # green
    base0A = "#2a9090"; # teal
    base0B = "#4ad865"; # green brillante
    base0C = "#d4722a"; # orange
    base0D = "#e8c030"; # oro
    base0E = "#1a6030"; # dark green
    base0F = "#b84020"; # rosso-bronzo alt
  };

  inherit (lib) mkIf mkForce removePrefix;

  rawHex = removePrefix "#";
in
{
  nixos =
    { pkgs, user, ... }:
    let
      nixos = self.modules.nixos;
    in
    {
      imports = with nixos; [ sddm ];

      fonts.packages = with pkgs; [ (callPackage ./ailerons.nix { }) ];

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

            profileIcons."${user.name}" = profile;

            settings = {
              "LockScreen" = {
                blur = 0;
                background = "${imgName background}";
              };
              "LockScreen.Clock" = {
                position = "top-right";
                align = "center";
                color = palette.base0B;
                font-size = 150;
                font-family = "Ailerons";
              };
              # TODO: understand why it doesn't merge
              "LockScreen.Date" = {
                format = "dd/MM/yyyy";
                locale = "it_IT";
                color = palette.base0B;
                font-size = 40;
                font-family = "Ailerons";
              };
              "LockScreen.Message".display = false;
              "LoginScreen" = {
                blur = 48;
                background = "${imgName background}";
              };
              "LoginScreen.LoginArea.Username".font-family = "Ailerons";
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
        # for swaylock
        home.packages = with pkgs; [ webp-pixbuf-loader ];

        home.pointerCursor = {
          size = mkForce 28;
          name = mkForce "LyraX-cursors";
          package = mkForce pkgs.lyra-cursors;
        };

        stylix = {
          base16Scheme = palette;
          image = background;
          polarity = polarity;
          opacity.terminal = opacity;
        };

        hyprnix.settings =
          let
            active_border = {
              colors = [
                "rgb(${rawHex palette.base0A})"
                "rgb(${rawHex palette.base0B})"
              ];
            };
          in
          {
            general.col.active_border = active_border;
            group = {
              col.border_active = mkForce active_border;
              groupbar = rec {
                text_color = mkForce "rgb(${rawHex palette.base0B})";
                text_color_inactive = mkForce "rgb(${rawHex palette.base04})";
                col.active = text_color;
                col.inactive = text_color_inactive;
              };
            };

            animation = mkIf (host.performance != "low") {
              borderangle = {
                speed = 20;
                bezier = "linear";
                style = "loop";
              };
            };
          };

        programs = {
          ags-bar.colors = {
            base16 = palette;
            overrides = {
              connection = {
                foreground = palette.base09;
                foreground-hover = palette.base0A;
              };

              time = {
                clock.foreground = palette.base0B;
                date.foreground = {
                  normal = palette.base0B;
                  hover = palette.base0E;
                };
                calendar = {
                  background.selected = palette.base0B;
                  outline.today = palette.base0B;
                };
              };
            };
          };

          rofi.theme =
            let
              inherit (config.lib.formats.rasi) mkLiteral;
            in
            {
              "*".selected = mkForce (mkLiteral palette.base0E);
            };

          cava.settings = {
            color = {
              gradient = 1;
              gradient_color_1 = mkForce "'${palette.base0B}'";
              gradient_color_2 = mkForce "'${palette.base0F}'";
              gradient_color_3 = mkForce "'${palette.base09}'";
              gradient_color_4 = mkForce "'${palette.base0A}'";
            };
          };

        };
      };
    };
}
