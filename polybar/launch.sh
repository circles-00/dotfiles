#!/bin/bash

THEME="tokyonight"

# Terminate already running bar instances
killall polybar
# kill -9 $(pgrep -f 'polybar') >/dev/null 2>&1

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

CONFIG_DIR=$(dirname $0)/themes/$THEME/config.ini

# Launch Polybar, using default config location ~/.config/polybar/config
# polybar main &

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [[ "$m" == "eDP-1" ]]; then
      MONITOR=$m TRAY_POSITION=none  polybar -c $CONFIG_DIR main &
    else
      MONITOR=$m TRAY_POSITION=right polybar -c $CONFIG_DIR main &
    fi
  done
fi

echo "Polybar launched..."
