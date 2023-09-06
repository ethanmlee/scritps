#!/bin/sh

case $1 in
  button/lid)
    case $3 in
      close)

        # functions
        lidState() {grep -q closed /proc/acpi/button/lid/*/state}

        isDesktopMode() {test -f /tmp/desktop_mode.tmp}

        isLocked() {pgrep -f physlock > /dev/null}

        lockAndHibernate() {
          ! isLocked && ~/.scripts/lock.sh &
          doas systemctl hibernate
        }

        # start of logic
        if ! isDesktopMode && lidState; then
          sleep 5
        fi
        
        UPOWER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | awk '/state/ {print $NF}')
        [ ! isDesktopMode ] && lidState && ([ "$UPOWER" = "charging" ] || [ "$UPOWER" = "fully-charged" ]) && ! isLocked && ~/.scripts/lock.sh
        [ ! isDesktopMode ] && lidState && ([ "$UPOWER" != "charging" ] && [ "$UPOWER" != "fully-charged" ]) && lockAndHibernate
        ;;
    esac
    ;;

esac
