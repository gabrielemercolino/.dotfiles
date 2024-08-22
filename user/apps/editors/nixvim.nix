{ inputs, systemSettings, ... }:

{
  home.packages = [
    inputs.nixvim.packages.${systemSettings.system}.default
  ];
}
