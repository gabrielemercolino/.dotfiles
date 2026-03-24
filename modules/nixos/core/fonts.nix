{ self, ... }:
{
  flake.modules.nixos = {
    core.imports = [ self.modules.nixos.fonts ];

    fonts =
      { pkgs, ... }:
      {
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
  };
}
