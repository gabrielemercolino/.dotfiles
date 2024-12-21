is_disconnected=$(LANG=en_US.UTF-8 nmcli g | grep -oE "disconnected")
essid=$(nmcli -t -f NAME connection | awk 'NR==1')
type=$(nmcli -t -f TYPE connection | awk 'NR==1')

# defaults are for desktop with ethernet
wired="true"
connected="true"
name="\"${essid}\""

if [[ "$type" != *"ethernet"* ]]; then
  wired="false"
fi

if [ $is_disconnected ] ; then
  connected="false"
  name="\"disconnected\""
fi

json="{"
json+="\"wired\": $wired,"
json+="\"connected\": $connected,"
json+="\"name\": $name"
json+="}"

echo $json
