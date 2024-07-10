#!/bin/zsh

main() {
  PLAYER="spotifyd"

  player_status=$(playerctl --player=$PLAYER status)

  # TODO: I can probably merge these 2 if statements, but I'm not a hardcode basher, so imma leave it like this
  if ! pgrep -x $PLAYER >/dev/null; then
    echo ""; exit
  fi

  if [ $player_status != "Playing" ]; then
    echo ""; exit
  fi

  song_details=$(playerctl metadata $PLAYER --format "{{ title }} - {{ artist }}")

  echo "$song_details"
}

main "$@"
