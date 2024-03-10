{ pkgs, userSettings, systemSettings, ... }:

let
nixvimScript = ''
nix run github:gabrielemercolino/.nixvim
'';

in
{
  home.packages = [
    (pkgs.writeScriptBin "nvim" nixvimScript)
  ];
}
