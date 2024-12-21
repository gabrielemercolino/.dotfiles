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

      mkdir -p "$HOME/Videos/"
      file_name="$HOME/Videos/screenrecord_$(date +%Y-%m-%d-%T).mp4"
      default_sink="$(pactl get-default-sink).monitor"

      if [ -f $lock ]; then
        rm "$lock"

        if is_wayland_session; then 
          pkill wl-screenrec 
        else 
          pkill ffmpeg

          # as audio and video are captured separately, at the start they are not in sync
          # by testing I found out that audio seems to start after video, so I need to find
          # the difference and cut the initial part from the video
          video_duration=$(ffprobe -i /tmp/screen-record.mp4 -show_entries format=duration -v quiet -of csv="p=0")
          audio_duration=$(ffprobe -i /tmp/screen-record.aac -show_entries format=duration -v quiet -of csv="p=0")
          duration_diff=$(awk "BEGIN {print $video_duration - $audio_duration}")

          # shellcheck disable=SC2086
          ffmpeg -ss $duration_diff -i /tmp/screen-record.mp4 -i /tmp/screen-record.aac -c:v copy -c:a copy -shortest $file_name

          rm /tmp/screen-record.mp4
          rm /tmp/screen-record.aac
        fi

        exit 0
      else
        touch "$lock"
      fi

      if is_wayland_session; then
        # shellcheck disable=SC2086
        wl-screenrec --audio --audio-device $default_sink -b "1 MB" -f $file_name
      else
        capture_size=$(xrandr | grep '\*' | awk '{print $1}')
        video_options="-c:v libx264 -b:v 1M -preset medium -profile:v high -pix_fmt yuv420p" #profile and pix_fmt for compatibility
        audio_options="-c:a aac -b:a 192k"

        # shellcheck disable=SC2086
        ffmpeg -f x11grab -video_size $capture_size -i :0.0 $video_options /tmp/screen-record.mp4 &
        # shellcheck disable=SC2086
        ffmpeg -f pulse -i $default_sink $audio_options /tmp/screen-record.aac &
      fi

    '';
}
