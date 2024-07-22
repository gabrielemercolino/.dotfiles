{ pkgs, spicetify-nix, ... }:

let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in
{
  # import the flake's module for your system
  imports = [ spicetify-nix.homeManagerModules.default ];

  programs.spicetify = {
    enable = true;
    
    enabledExtensions = with spicePkgs.extensions; [
       adblock
       hidePodcasts
       shuffle # shuffle+ (special characters are sanitized out of extension names)
    ];
    
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };
}
