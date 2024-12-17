is_disconnected=$(LANG=en_US.UTF-8 nmcli g | grep -oE "disconnected")
essid=$(LANG=en_US.UTF-8 nmcli c | awk 'NR==2' | awk '{print $1}')

icon="󰖩"
text="${essid}"
col="#a1bdce"

if [ $status ] ; then
  icon="󰖪"
  text=""
  col="#575268"
fi

if [[ "$1" == "--COL" ]]; then
  echo $col
elif [[ "$1" == "--ESSID" ]]; then
	echo $text
elif [[ "$1" == "--ICON" ]]; then
	echo $icon
fi
