battery_path='/sys/class/power_supply/BAT0'

# defaults are meant for desktop w/o battery
value="100"
charging="true"
tooltip="\"plugged\""

if [[ -d "$battery_path" ]]; then
  value=$(cat $battery_path/capacity)
  status=$(cat $battery_path/status)
  if [[ $status == "Discharging" ]]; then
    charging="false"
  fi
  tooltip="\"battery on $value%\""
fi


json="{"
json+="\"value\": $value,"
json+="\"charging\": $charging,"
json+="\"tooltip\": $tooltip"
json+="}"

echo $json
