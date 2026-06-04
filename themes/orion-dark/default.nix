{ self, lib, ... }:
let
  polarity = "dark";
  opacity = 0.8;

  profile = ./profile.webp;
  background = ./background.webp;

  palette = {
    base00 = "#0d0306"; # bg - nero con velatura rossa profonda
    base01 = "#180509"; # bg0_h - quasi nero, rosso percepibile
    base02 = "#2a0b10"; # bg1 - rosso sangue scuro
    base03 = "#3e1218"; # bg2 - cremisi medio
    base04 = "#871a22"; # bg3 - rosso più esposto
    base05 = "#e8cfa8"; # fg - oro pallido caldo
    base06 = "#d4b88a"; # fg1 - oro desaturato
    base07 = "#f5e4c4"; # fg2 - crema chiaro
    base08 = "#d92b2b"; # red - cremisi vivo (errori)
    base09 = "#d4722a"; # orange - warning
    base0A = "#f0a830"; # yellow - oro brillante (attenzione)
    base0B = "#3ab85a"; # green - accento secondario
    base0C = "#2ea04a"; # aqua - verde più acceso, appena sotto base0B
    base0D = "#4a6070"; # blu spento
    base0E = "#7a1a19"; # cremisi scuro
    base0F = "#b85a1a"; # orange alt - bronzo ruggine
  };

  inherit (lib) mkIf mkForce removePrefix;

  rawHex = removePrefix "#";

  wfFont = "Ailerons";
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
                position = "top-left";
                align = "center";
                color = palette.base08;
                font-size = 150;
                font-family = wfFont;
              };
              # TODO: understand why it doesn't merge
              "LockScreen.Date" = {
                format = "dd/MM/yyyy";
                locale = "it_IT";
                color = palette.base08;
                font-size = 40;
                font-family = wfFont;
              };
              "LockScreen.Message".display = false;
              "LoginScreen" = {
                blur = 48;
                background = "${imgName background}";
              };
              "LoginScreen.LoginArea.Username".font-family = wfFont;
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
          name = mkForce "LyraS-cursors";
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
                "rgb(${rawHex palette.base08})"
              ];
            };
          in
          {
            general.col.active_border = active_border;
            group = {
              col.border_active = mkForce active_border;
              groupbar = rec {
                text_color = mkForce "rgb(${rawHex palette.base08})";
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
                clock.foreground = palette.base08;
                date.foreground = {
                  normal = palette.base08;
                  hover = palette.base0E;
                };
                calendar = {
                  background.selected = palette.base08;
                  outline.today = palette.base08;
                };
              };
            };
          };

          hyprlock = {
            settings = {
              "$text" = "rgb(${palette.base05})";
              "$text_alpha" = "rgba(${palette.base05}55)";
              "$font" = wfFont;
            };
          };

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
