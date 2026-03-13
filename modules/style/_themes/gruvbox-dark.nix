{pkgs, ...}: {
  system = "base16";
  name = "Gruvbox Dark";
  author = "https://github.com/morhetz/gruvbox";
  polarity = "dark";

  background = pkgs.fetchurl {
    url = "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/solar-system-minimal.png";
    hash = "sha256-wDJxF4amPaYiwEl80K9ff5dlHoab2rDjbjHAQS1s6sk=";
  };

  palette = {
    base00 = "282828"; # bg (background)
    base01 = "1d2021"; # bg0_h (hard background)
    base02 = "3c3836"; # bg1
    base03 = "504945"; # bg2
    base04 = "665c54"; # bg3
    base05 = "ebdbb2"; # fg (foreground/text)
    base06 = "d5c4a1"; # fg2
    base07 = "fbf1c7"; # fg0 (light foreground)
    base08 = "fb4934"; # red (bright red)
    base09 = "fe8019"; # orange (bright orange)
    base0A = "fabd2f"; # yellow (bright yellow)
    base0B = "b8bb26"; # green (bright green)
    base0C = "8ec07c"; # aqua (bright aqua/teal)
    base0D = "83a598"; # blue (bright blue)
    base0E = "d3869b"; # purple (bright purple)
    base0F = "d65d0e"; # orange alternate (per flamingo)
  };
}
