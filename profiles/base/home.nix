{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../gab/home-manager
    inputs.sops-nix.homeManagerModules.sops
  ];

  xdg =
    let
      xdg = import ./xdg.nix { inherit config lib pkgs; };
    in
    {
      enable = true;
      desktopEntries = xdg.desktopEntries;
      mimeApps = {
        enable = true;
        defaultApplications = xdg.defaultApplications;
      };
    };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";

    secrets = {
      "ssh/priv" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519";
      };
      "ssh/pub" = {
        path = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };
  };

  # use zsh by default
  gab.shell.zsh.enable = true;

  programs.zellij = {
    enable = true;
    settings = {
      on_force_close = "quit";
      pane_frames = false;
      default_layout = "compact";
      default_mode = "locked";
      show_release_notes = false;
      show_startup_tips = false;
      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };
}
