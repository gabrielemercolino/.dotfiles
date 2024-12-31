read_cpu_values() {
  awk '/^cpu/ {print $1, $2, $3, $4, $5, $6, $7, $8, $9, $10}' /proc/stat
}

calculate_cpu_usage() {
  local cpu_name=$1
  local user1=$2 nice1=$3 system1=$4 idle1=$5 iowait1=$6 irq1=$7 softirq1=$8 steal1=$9 guest1=${10}
  local cpu_name_2=${11} #unused
  local user2=${12} nice2=${13} system2=${14} idle2=${15} iowait2=${16} irq2=${17} softirq2=${18} steal2=${19} guest2=${20}

  local user_diff=$((user2 - user1))
  local nice_diff=$((nice2 - nice1))
  local system_diff=$((system2 - system1))
  local idle_diff=$((idle2 - idle1))
  local iowait_diff=$((iowait2 - iowait1))
  local irq_diff=$((irq2 - irq1))
  local softirq_diff=$((softirq2 - softirq1))
  local steal_diff=$((steal2 - steal1))
  local guest_diff=$((guest2 - guest1))

  local active_time=$((user_diff + nice_diff + system_diff + irq_diff + softirq_diff + steal_diff + guest_diff))
  local total_time=$((active_time + idle_diff + iowait_diff))

  usage=$(echo $active_time $total_time | awk '{print ($1 / $2) * 100}')
  LC_NUMERIC=C printf "%.2f" "$usage"
}

mapfile -t initial_stats < <(read_cpu_values)
sleep 1
mapfile -t final_stats < <(read_cpu_values)

json="["

for i in "${!initial_stats[@]}"; do
  initial_line=(${initial_stats[i]})
  final_line=(${final_stats[i]})

  cpu_usage=$(calculate_cpu_usage "${initial_line[@]}" "${final_line[@]}")
  json+="{\"usage\": $cpu_usage},"
done

json="${json%,}"
json+="]"
echo $json
