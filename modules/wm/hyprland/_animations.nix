_: {
  animation = {
    windowsIn = {
      enable = true;
      duration = 100;
      curve = "easeOutCirc";
      style = "popin 60%";
    };
    fadeIn = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
    };
    # window destruction
    windowsOut = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
      style = "popin 60%";
    };
    fadeOut = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
    };
    # window movement
    windowsMove = {
      enable = true;
      duration = 200;
      curve = "easeInOutCubic";
      style = "popin";
    };
    workspaces = {
      enable = true;
      duration = 200;
      curve = "easeOutCirc";
      style = "slide";
    };
  };
}
