#!/bin/zsh

main() {

pause=$(dunstctl is-paused)

## Toggle dunst's state icon
echo $pause

if [ $pause = "false" ]; then
  notify-send "🔕 Notifications Paused"
  sleep 3
  dunstctl set-paused toggle
elif [ $pause = "true" ]; then
  dunstctl set-paused toggle
  dunstctl history-close-all
  notify-send "🔔 Notifications Resumed"
fi
}

 main "$@"
