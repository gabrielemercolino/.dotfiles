{
  config,
  pkgs,
}: {
  settings = let
    mpd = config.services.mpd;
  in {
    mpd_host = mpd.network.listenAddress;
    mpd_port = mpd.network.port;

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
