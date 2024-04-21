xrandr --output eDP1 --mode 1920x1080 --rate 60 --preferred

set -l touchpad_id (xinput | awk 'match($0, /Touchpad\s+id=([0-9]+)/, ary) { print ary[1] }' | head -n 1)
set -l natural_scrolling_id 314
set -l click_method 352
xinput set-prop $touchpad_id $natural_scrolling_id 1
xinput set-prop $touchpad_id $click_method 0 1

setxkbmap -layout us,ru -option caps:ctrl_modifier -option grp:toggle
