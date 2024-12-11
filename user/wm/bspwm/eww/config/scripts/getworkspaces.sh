xprop -spy -root _NET_CURRENT_DESKTOP | while read -r line; do
    current_workspace=$(wmctrl -d | grep '*' | awk '{print $1}')

    bar='
      (box
        :class "workspaces"
        :orientation "h"
        :spacing 5
        :space-evenly false
    '

    for i in $(wmctrl -d | awk '{print $1}'); do
      if [ "$i" -eq "$current_workspace" ]; then
        bar+='(button :onclick "wmctrl -s $i" :class "w'
        bar+="$((i+1))"
        bar+='" "")'
      else
        bar+='(button :onclick "wmctrl -s $i" :class "w'
        bar+="$((i+1))"
        bar+='" "")'
      fi
    done

    bar+=')'

    echo $bar
done
