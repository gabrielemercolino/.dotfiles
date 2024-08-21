{ ... }:

{
  programs.mangohud = {
    enable = true;
    settings = {
      hud_compact = true;

      arch = true;
      fsr = true;

      ram = true;
      vram = true;
      
      frametime = true;
      throttling_status_graph = true;
      
      vulkan_driver = true;
      wine = true;
      gamemode = true;
      present_mode = true;

      cpu_mhz = true;
      cpu_power = true;
      cpu_temp = true;
    
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_temp = true;
    };
  };

  home.sessionVariables = {
    # forces the use of the config file as if used by gamescope it is not loaded
    "MANGOHUD_CONFIGFILE" = "$HOME/.config/MangoHud/MangoHud.conf";
  };
}
