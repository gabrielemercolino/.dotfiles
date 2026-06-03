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
      { config, ... }:
      let
        cfg = config.gab.login.sddm;
      in
      {
        imports = [ inputs.silentSDDM.nixosModules.default ];

        options.gab.login.sddm = {
          enable = lib.mkEnableOption "sddm";
        };

        config = lib.mkIf cfg.enable {
          programs.silentSDDM = {
            enable = true;
            theme = "default";

            settings = {
              "LoginScreen.MenuArea.Keyboard".display = false;
              "LockScreen.Date" = {
                format = "dd/MM/yyyy";
                locale = "it_IT";
              };
            };
          };
        };
      };
  };
}
