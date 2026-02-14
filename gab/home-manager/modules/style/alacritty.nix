{lib, ...}: {
  programs.alacritty.settings = {
    window = {
      decorations = lib.mkForce "None";
      blur = lib.mkForce false;
    };
  };
}
