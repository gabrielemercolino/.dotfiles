{ pkgs, ... }:

{
  environment.shells = with pkgs; [ bash ];
  users.defaultUserShell = pkgs.bash;
}
