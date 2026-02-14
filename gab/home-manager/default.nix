{inputs, ...}: {
  imports = [
    ../common
    (inputs.import-tree ./modules)
  ];
}
