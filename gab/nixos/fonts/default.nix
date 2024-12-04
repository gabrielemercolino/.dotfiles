{ pkgs, ... }:

{
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Inconsolata"
          "DejaVuSansMono"
          "JetBrainsMono"
          "Meslo"
        ];
      })
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
}
