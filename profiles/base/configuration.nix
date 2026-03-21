{
  imports = [
    ../../gab/nixos
  ];

  # for battery managment
  services.upower.enable = true;
}
