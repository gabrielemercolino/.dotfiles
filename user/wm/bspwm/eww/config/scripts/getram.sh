LC_NUMERIC=C printf "%.0f\n" $(free -m | grep Mem | awk '{print ($3/$2)*100}')
