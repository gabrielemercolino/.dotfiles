{
  config,
  pkgs,
}: {
  package = pkgs.ncmpcpp.override {visualizerSupport = true;};
  settings = let
    mpd = config.services.mpd;
  in {
    mpd_host = mpd.network.listenAddress;
    mpd_port = mpd.network.port;

    visualizer_in_stereo = "yes";
    visualizer_data_source = "/tmp/mpd.fifo";
    visualizer_output_name = "my_fifo";
    visualizer_type = "spectrum";
    visualizer_look = "●▋";
    visualizer_color = "magenta,red,yellow,white";

    autocenter_mode = "yes";
    centered_cursor = "yes";
    user_interface = "classic";

    playlist_display_mode = "columns";
    browser_display_mode = "columns";
    search_engine_display_mode = "columns";
    playlist_editor_display_mode = "columns";

    header_visibility = "yes";
    statusbar_visibility = "yes";
    titles_visibility = "yes";
    enable_window_title = "yes";

    song_columns_list_format = "(0)[]{t|f:Title}";
    song_status_format = "$7 $b$8%t $7";
    song_window_title_format = "Now Playing ..";

    progressbar_look = "━━━";
    progressbar_elapsed_color = "cyan";

    colors_enabled = "yes";
    header_window_color = "cyan";
    volume_color = "green";
    main_window_color = "white";
    statusbar_color = "yellow";
    state_line_color = "blue";
  };
}
