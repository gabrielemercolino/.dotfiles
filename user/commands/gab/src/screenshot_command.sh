file_name=~/Pictures/screenshot_$(date +%Y-%m-%d-%T).png
area=${args[--area]}

mkdir -p $HOME/Pictures

if [ $area ]; then
  # slurp to capture area
  grim -g "$(slurp)" $file_name
else
  grim $file_name
fi 

echo $file_name
