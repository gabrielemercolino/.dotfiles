brightness=$(LC_NUMERIC=C brightnessctl g)
max_brightness=$(LC_NUMERIC=C brightnessctl m)
LC_NUMERIC=C printf "%.0f\n" $(echo "$brightness $max_brightness" | awk '{print ($1/$2)*100}')
