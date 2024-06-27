{ config, pkgs, userSettings, ... }:

{
  imports = [
	../base/home.nix
  #../../user/apps/editors/sublime.nix
  #../../user/apps/editors/vscodium.nix
  ../../user/apps/editors/jetbrains.nix
  ../../user/apps/editors/nixvim.nix
  ../../user/apps/editors/zed.nix
  ../../user/apps/utilities
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

}
