{
  writeShellApplication,
  ffmpeg_6-full,
  wayland ? false,
}:

writeShellApplication {
  name = "screen-shot";

  runtimeInputs = [ ffmpeg_6-full ];

  text = # bash
    ''
      mkdir -p "$HOME/Pictures/"
      file_name="$HOME/Pictures/screenshot_$(date +%Y-%m-%d-%T).png"
      #TODO: get size dinamically
      screen_size=$(xrandr | grep '\*' | awk '{print $1}')

      # shellcheck disable=SC2086
      ffmpeg -f x11grab -video_size $screen_size -framerate 1 -i :0.0 -vframes 1 $file_name
    '';
}
