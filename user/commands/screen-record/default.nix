{
  writeShellApplication,
  ffmpeg_6-full,
  wl-screenrec,
}:

writeShellApplication {
  name = "screen-record";

  runtimeInputs = [
    ffmpeg_6-full
    wl-screenrec
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

      lock="/tmp/screenrecord.lock"

      if [ -f $lock ]; then
        rm "$lock"
        
        if is_wayland_session; then 
          pkill wl-screenrec 
        else 
          pkill ffmpeg
        fi

        exit 0
      else
        touch "$lock"
      fi

      mkdir -p "$HOME/Videos/"
      file_name="$HOME/Videos/screenrecord_$(date +%Y-%m-%d-%T).mp4"
      default_sink="$(pactl get-default-sink).monitor"

      if is_wayland_session; then
        # shellcheck disable=SC2086
        wl-screenrec --audio --audio-device $default_sink -b "1 MB" -f $file_name
      else
        capture_size=$(xrandr | grep '\*' | awk '{print $1}')  
        video_options="-c:v libx264 -b:v 1M -preset medium"
        audio_options="-c:a aac -b:a 192k"

        # shellcheck disable=SC2086
        ffmpeg -f x11grab -video_size $capture_size -i :0.0 \
          -f pulse -i $default_sink  \
          $video_options $audio_options \
          $file_name
      fi

    '';
}
