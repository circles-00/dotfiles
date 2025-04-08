#!/bin/zsh

main() {
  pause=$(dunstctl is-paused)

## Toggle dunst's state icon
echo $pause

if [ $pause = "false" ]; then
  dunstctl set-paused true
  polybar-msg hook dnd 2
elif [ $pause = "true" ]; then
  dunstctl set-paused false
  polybar-msg hook dnd 1
  notify-send "🔔 Notifications Resumed"
fi
}

main "$@"
