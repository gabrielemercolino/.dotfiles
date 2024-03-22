{ config, pkgs, userSettings, systemSettings, ... }:

{
  imports = [
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;		

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    # Whether to enable patching wlroots for better Nvidia support
    enableNvidiaPatches = true;
  };

  home.packages = with pkgs; [
    hyprland-protocols

    wtype
    wev
    wlr-randr
    wl-clipboard

    libva-utils

    libsForQt5.qt5.qtwayland
    qt6.qtwayland

    xdg-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
  ];
  
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$terminal" = userSettings.terminal;
    bindm = [
      # Move/resize windows with mainMod + LMB/RMB and dragging
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    binde = [
      # Brightness control
      ", XF86MonBrightnessUp, exec, ${pkgs.brightnessctl}/bin/brightnessctl set +5%"
      ", XF86MonBrightnessDown, exec, ${pkgs.brightnessctl}/bin/brightnessctl set 5%-"
      
      # Volume control
      ", XF86AudioRaiseVolume, exec, ${pkgs.pamixer}/bin/pamixer -i 5"
      ", XF86AudioLowerVolume, exec, ${pkgs.pamixer}/bin/pamixer -d 5"
    ];
    bind = [
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod, Q, killactive," 
      "$mainMod, M, exit, "
      "$mainMod, E, exec, dolphin"
      "$mainMod, V, togglefloating, "
      "$mainMod, R, exec, ${pkgs.rofi}/bin/rofi -show drun"
      "$mainMod, P, pseudo, # dwindle"
      "$mainMod, J, togglesplit,"
      "$mainMod, W, exec, pkill .waybar-wrapped && ${pkgs.waybar}/bin/waybar"

      # Override power-off and reboot commands
      "$mainMod SHIFT, R, exec, systemctl reboot"
      "$mainMod SHIFT, P, exec, systemctl poweroff"
      ", XF86PowerOff, exec, "
     
      "$mainMod SHIFT, H, exec, ${pkgs.kitty}/bin/kitty ${pkgs.btop}/bin/btop"
    
      # Audio control
      ", XF86AudioMute, exec, ${pkgs.pamixer}/bin/pamixer -t"

      # Move focus with mainMod + arrow keys
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
    ] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
          "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ])
        10)
      );
    };

  wayland.windowManager.hyprland.extraConfig = ''
# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,highres,auto,1

# Some default env vars.
env = XCURSOR_SIZE,24

exec-once = ${pkgs.waybar}/bin/waybar

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle

    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    
    blur {
        enabled = true
        size = 3
        passes = 1
    }

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = ${systemSettings.keyLayout}
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = on
}

misc {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    force_default_wallpaper = 0 # Set to 0 to disable the anime mascot wallpapers
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
    '';
}
