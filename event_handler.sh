#!/bin/sh
case $1 in
  # only usefull for laptops
  # /etc/systemd/logind.conf: HandleLidSwitch=ignore
  button/lid)
    case $3 in
      close)
        #if not in desktop mode
        [ ! -f /tmp/desktop_mode.tmp ] && \

        #and if lid is closed
        LID_STATE=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}') && \
        [ "$LID_STATE" = "closed" ] && \

        #then lock system and sleep for 5 seconds
        lock.sh & \
        sleep 5 && \

        #then if lid is still closed
        LID_STATE_AGAIN=$(cat /proc/acpi/button/lid/*/state | awk '{print $2}') && \
        [ "$LID_STATE_AGAIN" = "closed" ] && \

        #and if physlock is still running
        pgrep -f physlock > /dev/null && \

        #and if the battery state is not charging or fully charged
        BATTERY_STATE=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | awk '/state/ {print $NF}') && \
        { [ "$BATTERY_STATE" != "charging" ] && [ "$BATTERY_STATE" != "fully-charged" ]; } && \

        #then hibernate
        doas systemctl hibernate
        ;;
    esac
    ;;

#  button/mute | button/volumedown | button/volumeup)
#    pkill dwmbar.sh
#    dwmbar.sh & disown
#    ;;

esac

