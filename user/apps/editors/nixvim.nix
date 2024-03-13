{ inputs, pkgs, userSettings, systemSettings, ... }:

let
nixvimScript = ''
nix run github:gabrielemercolino/.nixvim
'';

in
{
  home.packages = [
    #(pkgs.writeScriptBin "nvim" nixvimScript)
    inputs.nixvim.packages.${systemSettings.system}.default
  ];
}
