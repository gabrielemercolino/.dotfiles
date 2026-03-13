{pkgs, ...}: {
  system = "base16";
  name = "Synthwave Soft";
  author = "Custom synthwave theme (desaturated)";
  polarity = "dark";

  opacity = 0.8;

  background = pkgs.fetchurl {
    url = "https://images6.alphacoders.com/939/thumb-1920-939537.jpg";
    hash = "sha256-JClOUjwui6i9Bigcgp6F1xEZFJyxSVNmMtgVY0t5l8Y=";
  };

  palette = {
    base00 = "1a141f"; # deep purple-black background
    base01 = "2a1e3b"; # darker surface
    base02 = "3d2a52"; # elevated surface
    base03 = "544167"; # comments/subtle
    base04 = "75658b"; # dark foreground
    base05 = "cfc0d9"; # lavender text
    base06 = "e5dced"; # light lavender
    base07 = "f4f0f7"; # lightest
    base08 = "ea6d9c"; # soft pink
    base09 = "e89368"; # soft orange/peach
    base0A = "d4ac76"; # muted gold
    base0B = "7abf9e"; # soft teal/mint
    base0C = "70b8d4"; # soft cyan
    base0D = "7b93db"; # soft blue/purple
    base0E = "b88cce"; # soft purple
    base0F = "e87d9a"; # soft magenta
  };
}
