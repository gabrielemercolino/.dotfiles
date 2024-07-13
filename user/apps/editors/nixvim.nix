{ inputs, pkgs, userSettings, systemSettings, ... }:

{
  home.packages = [
    inputs.nixvim.packages.${systemSettings.system}.default
  ];
}
