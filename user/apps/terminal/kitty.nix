{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];

	programs.kitty = {
		enable = true;

		settings = with config; {
      font_size = stylix.fonts.sizes.terminal;

			color0  = "#" + lib.stylix.colors.base00;
      color1  = "#" + lib.stylix.colors.base08;
      color2  = "#" + lib.stylix.colors.base0B;
      color3  = "#" + lib.stylix.colors.base0A;
      color4  = "#" + lib.stylix.colors.base0D;
      color5  = "#" + lib.stylix.colors.base0E;
      color6  = "#" + lib.stylix.colors.base0C;
      color7  = "#" + lib.stylix.colors.base05;
      color8  = "#" + lib.stylix.colors.base03;
      color9  = "#" + lib.stylix.colors.base08;
      color10 = "#" + lib.stylix.colors.base0B;
      color11 = "#" + lib.stylix.colors.base0A;
      color12 = "#" + lib.stylix.colors.base0D;
      color13 = "#" + lib.stylix.colors.base0E;
      color14 = "#" + lib.stylix.colors.base0C;
      color15 = "#" + lib.stylix.colors.base07;
      color16 = "#" + lib.stylix.colors.base09;
      color17 = "#" + lib.stylix.colors.base0F;
      color18 = "#" + lib.stylix.colors.base01;
      color19 = "#" + lib.stylix.colors.base02;
      color20 = "#" + lib.stylix.colors.base04;
      color21 = "#" + lib.stylix.colors.base06;
		};
	};
}
