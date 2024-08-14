if [ -z "$1" ]
then
    echo "Usage: MediaPlayer2-cmd { PlayPause | Next | Previous | Stop | ... }"
    exit 1
fi


PLAYER="spotify"
player_dbus=$(dbus-send --print-reply --dest=org.freedesktop.DBus  /org/freedesktop/DBus org.freedesktop.DBus.ListNames | grep $PLAYER | awk '{print $2}' | tr -d '"')

if ! pgrep -x $PLAYER >/dev/null; then
  echo ""; exit
fi

dbus-send \
    --print-reply \
    --dest=$player_dbus \
    /org/mpris/MediaPlayer2 \
    org.mpris.MediaPlayer2.Player.$1
