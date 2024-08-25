{ pkgs, ... }:
{
  environment.shells = with pkgs; [nushell];
  users.defaultUserShell = pkgs.nushell;
}
