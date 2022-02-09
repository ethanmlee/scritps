#!/bin/sh
case $1 in

ac_adapter)
  sleep 1 && refreshbar.sh ;;

button/mute|button/volumeup|button/volumedown)
  sleep 0.1 && refreshbar.sh ;;

button/lid)
  case $3 in
  close)
    # if not in desktop mode and currently in default autorandr profile
    cat /tmp/desktop_mode.tmp
    if [ $? = 1 ] && [ $(autorandr --detected) = "default" ]; then
      # then wait 5 seconds if lid is closed
      grep -q closed /proc/acpi/button/lid/*/state
      if [ $? = 0 ] && [ $(autorandr --current) = "default" ]; then
        sleep 5
        # if lid is still closed after 5 seconds then run through lock/sleep if statements
        grep -q closed /proc/acpi/button/lid/*/state
        if [ $? = 0 ] && [ $(autorandr --current) = "default" ]; then
          # suspend and lock (do not relock if already locked)
          pgrep lock.sh
          if [ $? = 1 ]; then
            lock.sh & doas systemctl suspend
          else
            doas systemctl suspend
          fi
        fi
      fi
    fi
  esac ;;
esac

