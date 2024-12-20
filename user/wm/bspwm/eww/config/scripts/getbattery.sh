battery_path='/sys/class/power_supply/BAT0'

# defaults are meant for desktop w/o battery
has_battery="false"
value="100"
charging="true"
tooltip="plugged"

if [[ -d "$battery_path" ]]; then
  has_battery="true"
  value=$(cat $battery_path/capacity)
  status=$(cat $battery_path/status)
  if [[ $status == "Discharging" ]]; then
    charging="false"
  fi
  tooltip="\"battery on $value%\""
fi


json="{"
json+="\"has_battery\": $has_battery,"
json+="\"value\": $value,"
json+="\"charging\": $charging,"
json+="\"tooltip\": $tooltip"
json+="}"

echo $json
