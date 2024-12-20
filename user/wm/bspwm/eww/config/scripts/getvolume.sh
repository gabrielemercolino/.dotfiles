function print_volume() {
  default_source=$(pactl get-default-source)

  muted=$(LANG=en_US.UTF-8 pamixer --get-mute)
  volume=$(LANG=en_US.UTF-8 pamixer --get-volume)
  mic_volume=$(LANG=en_US.UTF-8 pamixer --source $default_source --get-volume)

  json="{"
  json+="\"volume\": $volume,"
  json+="\"mic_volume\": $mic_volume,"
  json+="\"muted\": $muted"
  json+="}"

  echo $json
}

print_volume

LANG=en_US.UTF-8 pactl subscribe | grep --line-buffered -E "sink|source" | while read -r line; do
  print_volume
done
