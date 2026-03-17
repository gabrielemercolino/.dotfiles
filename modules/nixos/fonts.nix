{
  flake.modules.nixos.fonts = {pkgs, ...}: {
    fonts = {
      packages = with pkgs; [
        nerd-fonts.inconsolata
        nerd-fonts.dejavu-sans-mono
        nerd-fonts.jetbrains-mono
        font-awesome
        material-design-icons
      ];

      fontconfig = {
        antialias = true;
        hinting = {
          style = "full";
        };
      };
    };
  };
}
