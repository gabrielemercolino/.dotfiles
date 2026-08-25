{ self, lib, ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      devshell.packages = with pkgs; [
        go
        gopls
        gcc
      ];

      packages.gab_unwrapped = pkgs.buildGoModule {
        pname = "gab_unwrapped";
        version = "2.0.1";
        src = ./.;

        vendorHash = null;

        nativeBuildInputs = with pkgs; [
          makeWrapper
          installShellFiles
        ];

        postInstall = ''
          installShellCompletion --cmd gab \
            --bash <($out/bin/gab completion bash) \
            --zsh <($out/bin/gab completion zsh) \
            --fish <($out/bin/gab completion fish)
        '';

        postFixup = ''
          wrapProgram $out/bin/gab \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nh ]}
        '';
      };

    };

  flake.modules.homeManager = {
    core.imports = [ self.modules.homeManager.gab ];

    gab =
      {
        config,
        pkgs,
        host,
        ...
      }:
      {
        options.gab.dotfilesDir = lib.mkOption {
          type = lib.types.str;
          default = "${config.home.homeDirectory}/.dotfiles";
          description = "Path to the dotfiles directory";
        };

        config =
          let
            gab = pkgs.symlinkJoin {
              name = "gab";
              paths = [ self.packages.${host.system}.gab_unwrapped ];
              nativeBuildInputs = [ pkgs.makeWrapper ];
              postBuild = ''
                wrapProgram $out/bin/gab \
                  --set DOTFILES_DIR "${config.gab.dotfilesDir}"
              '';
            };
          in
          {
            home.packages = [ gab ];
          };
      };
  };
}
