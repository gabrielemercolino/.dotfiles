{config}: let
  # mkLiteral strips the quotes
  inherit (config.lib.formats.rasi) mkLiteral;
  colors = config.lib.stylix.colors.withHashtag;
in {
  "*" = {
    background = mkLiteral "${colors.base01}";
    background-alt = mkLiteral "${colors.base00}";
    foreground = mkLiteral "${colors.base05}";
    selected = mkLiteral "${colors.base0E}";
  };

  window = {
    location = mkLiteral "center";
    anchor = mkLiteral "center";
    width = mkLiteral "500px";
    border-radius = mkLiteral "12px";
    background-color = mkLiteral "@background";
  };

  mainbox = {
    background-color = mkLiteral "transparent";
    children = ["inputbar" "listview"];
  };

  inputbar = {
    spacing = mkLiteral "10px";
    padding = mkLiteral "15px";
    background-color = mkLiteral "@background-alt";
    text-color = mkLiteral "@selected";
    children = ["prompt" "entry"];
  };

  prompt = {
    background-color = mkLiteral "inherit";
    text-color = mkLiteral "inherit";
  };

  entry = {
    background-color = mkLiteral "inherit";
    text-color = mkLiteral "inherit";
    cursor = mkLiteral "text";
    placeholder = "search...";
    placeholder-color = mkLiteral "inherit";
  };

  listview = {
    columns = 1;
    lines = 6;
    spacing = mkLiteral "5px";
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@foreground";
  };

  element = {
    margin = mkLiteral "8px";
    padding = mkLiteral "8px";
    border-radius = mkLiteral "12px";
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "@foreground";
    cursor = mkLiteral "pointer";
  };

  "element normal.normal" = {
    background-color = mkLiteral "@background";
    text-color = mkLiteral "@foreground";
  };

  "element selected.normal" = {
    border = mkLiteral "2px solid";
    border-color = mkLiteral "@selected";
    background-color = mkLiteral "@background-alt";
    text-color = mkLiteral "@foreground";
  };

  element-icon = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "inherit";
    size = mkLiteral "32px";
    cursor = mkLiteral "inherit";
  };

  element-text = {
    background-color = mkLiteral "transparent";
    text-color = mkLiteral "inherit";
    highlight = mkLiteral "inherit";
    cursor = mkLiteral "inherit";
    vertical-align = mkLiteral "0.5";
    horizontal-align = mkLiteral "0.5";
  };
}
