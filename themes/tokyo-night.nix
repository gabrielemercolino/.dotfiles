{pkgs}: {
  system = "base16";
  name = "Tokyo Night";
  author = "https://github.com/enkia/tokyo-night-vscode-theme";
  polarity = "dark";

  opacity = 0.7;

  background = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/ChapST1/gruvbox-wallpapers-web/master/wallpapers/mix/17.jpg";
    hash = "sha256-p5Mo1xA4jBZh6PPP0HK2YsuEBkP/gA27YDvxtuUrPHE=";
  };

  palette = {
    base00 = "1a1b26"; # background
    base01 = "16161e"; # darker background
    base02 = "2f3549"; # selection background
    base03 = "444b6a"; # comments, line highlighting
    base04 = "787c99"; # dark foreground
    base05 = "a9b1d6"; # default foreground
    base06 = "cbccd1"; # light foreground
    base07 = "d5d6db"; # lightest foreground
    base08 = "f7768e"; # red/pink
    base09 = "ff9e64"; # orange
    base0A = "e0af68"; # yellow
    base0B = "9ece6a"; # green
    base0C = "73daca"; # cyan/teal
    base0D = "7aa2f7"; # blue
    base0E = "bb9af7"; # purple/magenta
    base0F = "ff007c"; # bright red/pink accent
  };
}
