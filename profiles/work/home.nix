{ config, pkgs, userSettings, ... }:

{
  imports = [
	../base/home.nix
  #../../user/apps/editors/sublime.nix
  ../../user/apps/editors/vscodium.nix
  ../../user/apps/editors/jetbrains.nix
  ../../user/apps/editors/nixvim.nix
  ];  

  home.sessionVariables = {
    EDITOR = "nvim";
  };
  
}
