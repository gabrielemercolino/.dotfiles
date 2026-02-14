{pkgs, ...}: {
  programs.oh-my-posh.configFile = pkgs.writeText "oh-my-posh.yaml" (builtins.readFile ./oh-my-posh.yaml);
}
