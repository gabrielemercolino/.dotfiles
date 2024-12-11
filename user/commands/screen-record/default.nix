{
  writeShellApplication,
  ffmpeg_6-full,
  wayland ? false,
}:

writeShellApplication {
  name = "screen-record";

  runtimeInputs = [ ffmpeg_6-full ];

  text = # bash
    ''
      lock="/tmp/screenrecord.lock"

      if [ -f $lock ]
      then
        rm "$lock"
        pkill ffmpeg
        exit 0
      else
        touch "$lock"
      fi

      mkdir -p "$HOME/Videos/"
      file_name="$HOME/Videos/screenrecord_$(date +%Y-%m-%d-%T).mp4"
      screen_size=$(xrandr | grep '\*' | awk '{print $1}')

      default_sink="$(pactl get-default-sink).monitor"
      video_options="-c:v libx264 -crf 30"

      # shellcheck disable=SC2086
      ffmpeg -f x11grab -video_size $screen_size -framerate 25 -i :0.0 -f pulse -i $default_sink $video_options -preset medium $file_name
    '';
}
