{ lib, ... }:
{
  flake.modules.nixos.wayland =
    { pkgs, ... }:
    {
      services.xserver.enable = lib.mkDefault true;

      # needed for gpu-screen-recorder in a wayland context
      security.wrappers.gsr-kms-server = {
        owner = "root";
        group = "root";
        capabilities = "cap_sys_admin+ep";
        source = "${pkgs.gpu-screen-recorder}/bin/gsr-kms-server";
        setuid = false;
        setgid = false;
      };
    };
}
