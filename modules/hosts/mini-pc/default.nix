{ self, lib, ... }:
let
  inherit (self.modules) nixos homeManager;
  inherit (lib) getExe;
in
{
  hosts.mini-pc = {
    system = "x86_64-linux";

    audio = "pipewire";

    localization = {
      keyboard.layout = "it";
      locale = "it_IT.UTF-8";
      time.zone = "Europe/Rome";
    };

    user = {
      name = "gabriele";
      email = "ciruzzo032@noreply.codeberg.org";
    };

    theme = "roathe-dark";

    nixos =
      { pkgs, user, ... }:
      {
        imports = with nixos; [
          ./_hardware-configuration.nix
          style
          gaming
          login
          cli
          apps
          services
          preservation
        ];

        # has specific optimisations for this pc
        boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
        hardware.graphics.extraPackages = [ pkgs.libva ];
        nixpkgs.config.rocmSupport = true;

        # use zsh
        users.defaultUserShell = pkgs.zsh;
        programs.zsh.enable = true;

        gab = {
          preservation = {
            enable = true;

            directories = [
              "/var/lib/docker"
              "/var/lib/tailscale"
              "/var/lib/bluetooth"
              "/var/lib/sddm"
            ];
          };

          kernel = {
            # scx.enable = true;
          };

          cli = {
            bashmount.enable = true;
          };

          apps = {
            corectrl.enable = true;
            lact.enable = true;
          };

          gaming = {
            steam.enable = true;
            gamemode.enable = true;
            gamescope.enable = true;
            lsfg.enable = true;
          };

          services = {
            ssh.enable = true;
            direnv.enable = true;
            docker.enable = true;
          };

          login.sddm.enable = true;
        };

        services = {
          pipewire.wireplumber = {
            extraScripts."mini-pc-headset.lua" = builtins.readFile ./headset-route.lua;
            extraConfig."90-mini-pc-headset" = {
              "wireplumber.components" = [
                {
                  name = "mini-pc-headset.lua";
                  type = "script/lua";
                  provides = "hooks.mini-pc-headset";
                }
              ];
              "wireplumber.profiles".main."hooks.mini-pc-headset" = "required";
            };
          };
          xserver.excludePackages = [ pkgs.xterm ];
          tailscale.enable = true;
          sunshine = {
            enable = true;
            autoStart = true;
            capSysAdmin = true;
            settings = {
              capture = "wlr"; # avoids the XDG portal picker
              output_name = "DP-1";
              locale = "it";
            };
          };
        };
      };

    home =
      {
        pkgs,
        user,
        host,
        ...
      }:
      {
        imports = with homeManager; [
          style
          editors
          browsers
          wm
          gaming
          cli
          shell
          socials
          music
          services
        ];

        home.packages = with self.packages.${host.system}; [ cisco-packet-tracer ];

        programs.git = {
          enable = true;
          settings.user = {
            inherit (user) name email;
          };
        };

        programs.jujutsu = {
          enable = true;
          settings.user = {
            inherit (user) name email;
          };
        };

        sops.secrets = {
          "ssh/priv".path = "/home/${user.name}/.ssh/id_ed25519";
          "ssh/pub".path = "/home/${user.name}/.ssh/id_ed25519.pub";
        };

        gab = {
          editors = {
            helix.enable = true;
            gimp.enable = true;
            libresprite.enable = true;
            tiled.enable = true;
          };

          browsers = {
            zen.enable = true;
          };

          gaming = {
            mangohud.enable = true;
          };

          socials = {
            telegram.enable = true;
          };

          cli = {
            hermes.enable = true;
            yazi.enable = true;
            pi.enable = true;
            dsh.enable = true;
          };

          music = {
            mpd.enable = true;
            ncmpcpp.enable = true;
          };

          services = {
            resilio.enable = true;
          };

          shell = {
            zsh.enable = true;

            aliases = {
              ls = "${getExe pkgs.eza} --icons";
              ll = "${getExe pkgs.eza} -l --icons";
              la = "${getExe pkgs.eza} -la --icons";

              cd = "z"; # from zoxide
            };
          };

          wm = {
            umbriel = {
              enable = true;
              monitors = [
                {
                  output = "eDP-1";
                  mode = "1920x1080@60";
                  position = [
                    0
                    0
                  ];
                  scale = 1.0;
                }
              ];
            };

            hyprland = {
              enable = true;
              monitors = [
                {
                  output = "HDMI-A-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
                {
                  output = "DP-1";
                  mode = "1920x1080@100";
                  position = "auto";
                }
              ];
            };
          };
        };
      };
  };
}
