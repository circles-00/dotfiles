#!/bin/sh

main() {
# pause=0 means not paused
# pause=1 means pause enabled
pause=$(dunstctl is-paused)

# dunst_status=0 means dunst disabled
# dunst_status=1 means dunst enabled

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
