{
  config,
  pkgs,
  ...
}: let
  myShellAliases = {
    ls = "eza --icons";
    ll = "eza -l --icons";
    la = "eza -la --icons";
  };
in {
  programs.bash = {
    enable = true;
    shellAliases = myShellAliases;
  };

  programs.zsh = {
    enable = true;
    shellAliases = myShellAliases;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git" "sudo"];
    };
    syntaxHighlighting.enable = true;
  };

  home.packages = [pkgs.eza];
}
