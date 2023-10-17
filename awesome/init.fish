argparse 'scale=' -- $argv; or return
if set -q _flag_scale
  xrandr --output eDP1 --scale {$_flag_scale}x{$_flag_scale}
else
  xrandr --output eDP1 --scale 0.6x0.6
end

set -l touchpad_id 12
set -l natural_scrolling_id 314
xinput set-prop $touchpad_id $natural_scrolling_id 1

setxkbmap -layout us,ru -option caps:ctrl_modifier -option grp:toggle
