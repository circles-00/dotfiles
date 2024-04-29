#!/bin/sh

main() {

pause=$(dunstctl is-paused)

## Toggle dunst's state icon
case $pause in
  "false")
    echo "  🔔"
      ;;
        "true")
          echo "  🔕"
            ;;
        esac

        exit 0;
      }

main "$@"
