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

    enableCompletion = true;
    initExtra = ''
      # needed to load gab cli completions
      autoload -U bashcompinit && bashcompinit
      touch /tmp/gab_completions
      gab completions > /tmp/gab_completions
      source /tmp/gab_completions
      rm /tmp/gab_completions
    '';
  };

  home.packages = [pkgs.eza];
}
