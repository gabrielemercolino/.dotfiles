{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkForce removePrefix;

  rawHex = removePrefix "#";
in
rec {
  system = "base16";
  name = "Warframe kim dark";
  author = "https://github.com/gabrielemercolino";
  polarity = "dark";

  opacity = 0.8;

  #got it from https://x.com/shieldgating/status/2006520583383601201/
  profile = ./profile.png;
  background = ./background.png;

  palette = {
    base00 = "#1a0a0a"; # bg - rosso-marrone molto scuro
    base01 = "#0f0505"; # bg0_h - quasi nero con tinta rossa
    base02 = "#2a1515"; # bg1 - rosso scuro
    base03 = "#3d2020"; # bg2 - rosso-marrone medio
    base04 = "#4f2d2d"; # bg3 - rosso-marrone più chiaro
    base05 = "#e8d4b8"; # fg - beige dorato per testo
    base06 = "#d4bc9f"; # fg2 - beige caldo
    base07 = "#f5e8d0"; # fg0 - crema molto chiaro
    base08 = "#e85a4a"; # red - rosso vivo (errori)
    base09 = "#d4a855"; # orange - oro (warning)
    base0A = "#f0c674"; # yellow - oro brillante (attenzione)
    base0B = "#8fa870"; # green - verde oliva dorato (successo)
    base0C = "#7fa0a8"; # aqua - azzurro desaturato (info)
    base0D = "#8b9fc4"; # blue - blu pervinca pallido (links)
    base0E = "#b88b9f"; # purple - malva rosato
    base0F = "#c47a4a"; # orange alternate - bronzo ramato
  };

  home = {
    home.pointerCursor = {
      size = mkForce 28;
      name = mkForce "LyraG-cursors";
      package = mkForce pkgs.lyra-cursors;
    };

    xdg.configFile = {
      "ghostty/shader.glsl".source = ./ghostty-blazing-cursor.glsl;
    };

    wayland.windowManager.hyprland.settings =
      let
        active_border = "rgb(${rawHex palette.base0A}) rgb(${rawHex palette.base08})";
      in
      {
        general."col.active_border" = mkForce active_border;

        group = {
          "col.border_active" = mkForce active_border;
          groupbar = rec {
            text_color = mkForce "rgb(${rawHex palette.base08})";
            text_color_inactive = mkForce "rgb(${rawHex palette.base04})";
            "col.active" = text_color;
            "col.inactive" = text_color_inactive;
          };
        };

        animations.animation = [ "borderangle, 1, 20, linear, loop" ];
      };

    programs = {
      rofi.theme =
        let
          inherit (config.lib.formats.rasi) mkLiteral;
        in
        {
          "*" = {
            selected = mkForce (mkLiteral palette.base0F);
          };
        };

      ghostty.settings = {
        custom-shader = "shader.glsl";
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
}
