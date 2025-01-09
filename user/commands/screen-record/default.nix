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

  text =
    # bash
    ''
      function is_wayland_session() {
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
          return 0
        else
          return 1
        fi
      }

      function record_x11() {
        capture_size=$(xrandr | grep '\*' | awk '{print $1}')
        default_sink="$(pactl get-default-sink).monitor"
        video_options="-framerate 25 -c:v h264 -qp 0 -preset ultrafast"
        audio_options="-b:a 192k"

        # -nostdin is used because ffmpeg is run on background but without this
        # it would be blocked while trying to write output

        # shellcheck disable=SC2086
        ffmpeg -nostdin -f x11grab -video_size $capture_size -i :0.0 $video_options /tmp/screen-record.mkv &
        echo $! > /tmp/rec_pid

        # shellcheck disable=SC2086
        ffmpeg -nostdin -f pulse -i $default_sink $audio_options /tmp/audio-record.wav &
        echo $! > /tmp/aud_pid
      }

      function stop_x11() {
        file_name="$HOME/Videos/screenrecord_$(date +%Y-%m-%d-%T).mp4"

        kill -15 "$(cat /tmp/rec_pid)" "$(cat /tmp/aud_pid)"
        rm -f /tmp/rec_pid /tmp/aud_pid

        # i need to recode the video so it's more compatible with mobile devices
        ffmpeg -i /tmp/screen-record.mkv -i /tmp/audio-record.wav -r 25 -vsync cfr -profile:v high -pix_fmt yuv420p "$file_name"

        rm /tmp/screen-record.mkv /tmp/audio-record.wav
      }

      function record_wayland() {
        file_name="$HOME/Videos/screenrecord_$(date +%Y-%m-%d-%T).mp4"
        default_sink="$(pactl get-default-sink).monitor"

        #shellcheck disable=SC2086
        wl-screenrec --audio --audio-device $default_sink -b "1 MB" -f $file_name &
        echo $! > /tmp/rec_pid
      }

      function stop_wayland() {
        kill -15 "$(cat /tmp/rec_pid)"
        rm -f /tmp/rec_pid
      }

      if [ -z "$XDG_SESSION_TYPE" ]
      then
        echo "XDG_SESSION_TYPE is not set, aborting"
        exit 1
      fi

      mkdir -p "$HOME/Videos/"

      if [ -f /tmp/rec_pid ]; then
        (is_wayland_session && stop_wayland) || stop_x11
      else
        (is_wayland_session && record_wayland) || record_x11
      fi
    '';
}
