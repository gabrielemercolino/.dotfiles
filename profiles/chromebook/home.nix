{
  lib,
  pkgs,
  userSettings,
  ...
}: {
  imports = [
    ../base/home.nix
    ./theme.nix
    ../../user/commands/gab
  ];
  gab = {
    wm = {
      hyprland = {
        enable = true;
        monitors = ["eDP-1, 1920x1080@60, auto, 1" "DP-2, 1920x1080@60, auto, 1, mirror, eDP-1"];
      };

      bspwm = {
        enable = false;
      };
    };

    shell = {
      aliases = {
        ls = "${lib.getExe pkgs.eza} --icons";
        ll = "${lib.getExe pkgs.eza} -l --icons";
        la = "${lib.getExe pkgs.eza} -la --icons";

        cd = "z"; # from zoxide
      };

      commands.z.enable = true;
    };
    apps = {
      rofi.enable = true;
      kitty.enable = true;

      gimp.enable = true;
      yazi.enable = true;
      obsidian.enable = true;
      swaylock.enable = true;

      zen.enable = true;

      telegram.enable = true;

      helix.enable = true;
      idea-community.enable = true;

      resilio.enable = true;
    };
  };

  programs.git = {
    enable = true;
    settings.user = {
      inherit (userSettings) name;
      inherit (userSettings) email;
    };
  };
}
