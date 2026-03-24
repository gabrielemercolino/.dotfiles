{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.modules.nixos = {
    login.imports = [ self.modules.nixos.sddm ];

    sddm =
      {
        config,
        pkgs,
        user,
        loadTheme,
        ...
      }:
      let
        cfg = config.gab.login.sddm;

        theme = loadTheme { inherit config lib pkgs; };

        background = theme.background;
        profile = theme.profile or null;
        extras = theme.extras or { };

        imgName = img: if lib.isDerivation img then img.name else builtins.baseNameOf img;
      in
      {
        imports = [ inputs.silentSDDM.nixosModules.default ];

        options.gab.login.sddm = {
          enable = lib.mkEnableOption "sddm";
        };

        config = lib.mkIf cfg.enable {
          programs.silentSDDM = lib.mkMerge [
            {
              enable = true;
              theme = "default";

              backgrounds.bg = background;

              # TODO: add default so themes without it won't have the last profile pic set
              profileIcons = lib.mkIf (profile != null) {
                "${user.name}" = profile;
              };
              settings = {
                "LoginScreen" = {
                  blur = 32;
                  background = "${imgName background}";
                };
                "LoginScreen.MenuArea.Keyboard" = {
                  display = false;
                };
                "LockScreen" = {
                  blur = 0;
                  background = "${imgName background}";
                };
                "LockScreen.Date" = {
                  format = "dd/MM/yyyy";
                  locale = "it_IT";
                };
              };
            }
            (extras.silentSDDM or { })
          ];
        };
      };
  };
}
