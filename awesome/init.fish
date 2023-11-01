xrandr --output eDP1 --mode 1920x1080 --rate 60 --preferred

set -l touchpad_id 12
set -l natural_scrolling_id 314
xinput set-prop $touchpad_id $natural_scrolling_id 1

setxkbmap -layout us,ru -option caps:ctrl_modifier -option grp:toggle
