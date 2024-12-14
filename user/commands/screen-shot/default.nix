{
  writeShellApplication,
  ffmpeg_6-full,
  grim,
  slurp,
  wl-clipboard,
}:

writeShellApplication {
  name = "screen-shot";

  runtimeInputs = [
    ffmpeg_6-full
    grim
    slurp
    wl-clipboard
  ];

  text = # bash
    ''
      function is_wayland_session() {
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          return 0
        else
          return 1
        fi
      }

      if [ -z "$XDG_SESSION_TYPE" ]
      then
        echo "XDG_SESSION_TYPE is not set, aborting"
        exit 1
      fi

      mkdir -p "$HOME/Pictures/"
      file_name="$HOME/Pictures/screenshot_$(date +%Y-%m-%d-%T).png"

      if is_wayland_session; then
        capture_size=$(slurp)
        
        grim -g "$capture_size" "$file_name"
        wl-copy < "$file_name" # also copy to clipboard
      else
        #TODO: get size dinamically
        capture_size=$(xrandr | grep '\*' | awk '{print $1}')

        # shellcheck disable=SC2086
        ffmpeg -f x11grab -video_size $capture_size -framerate 1 -i :0.0 -vframes 1 $file_name

        #TODO: copy to clipboard if possible
      fi
    '';
}
