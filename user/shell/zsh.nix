{ pkgs, ... }:
let 
  myShellAliases = {
    ls = "eza --icons";
    ll = "eza -l --icons";
    la = "eza -la --icons";
  };
in
{
  programs.zsh = {
    enable = true;
    shellAliases = myShellAliases;
    
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "sudo"];
    };
    
    syntaxHighlighting.enable = true;
   
    autosuggestion.enable = true;
  };

  home.packages = [pkgs.eza];
}
