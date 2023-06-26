#!/bin/sh
case $1 in

button/lid)
  case $3 in
  close)
    # if not in desktop mode and currently in default autorandr profile
    cat /tmp/desktop_mode.tmp
    if [ $? = 1 ]; then
      # then wait 5 seconds if lid is closed
      grep -q closed /proc/acpi/button/lid/*/state
      if [ $? = 0 ]; then
        sleep 5
        # if lid is still closed after 5 seconds then run through lock/sleep if statements
        grep -q closed /proc/acpi/button/lid/*/state
        if [ $? = 0 ]; then
          # if not locked then lock and suspend else just suspend without locking
	  UPOWER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{ print $NF }')
	  if [ "$UPOWER" = "charging" ] || [ "$UPOWER" = "fully-charged" ]; then
	    pgrep -f physlock > /dev/null
            [ $? != 0 ] && ~/.scripts/lock.sh
          else
            pgrep -f physlock > /dev/null
            [ $? != 0 ] && ~/.scripts/lock.sh & doas systemctl hibernate || doas systemctl hibernate
	  fi
        fi
      fi
    fi
  ;;
  esac
;;
esac
