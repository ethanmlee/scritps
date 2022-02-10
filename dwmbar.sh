#!/bin/sh

STATUSBAR() {
  # Time
  TIME=$(date '+%a %d.%m.%+4Y %I:%M%P %Z')
  # Volume
  VOLUME=$(pamixer --get-volume-human)
  # Battery
  UPOWER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{ print $NF }')
  CAPACITY=$(cat /sys/class/power_supply/BAT?/capacity)
  CHARGE=↓; [ "$UPOWER" = "charging" ] || [ "$UPOWER" = "fully-charged" ] && CHARGE=↑
  BATTERY=$CAPACITY%$CHARGE; [ "$CAPACITY" = "100" ] && BATTERY=100%
  # Memory
  MEMORY=$(free -h | grep 'Mem' | awk '{ print $3 }')
  # CPU tempurature
  CPU=$(sensors acpitz-acpi-0 -u | grep temp1_input | awk '{ print $2 }' | sed 's/\..*//g')C
  # Desktop Mode status
  DESKTOP="";  cat /tmp/desktop_mode.tmp; [ $? = 0 ] && DESKTOP="  |"
  TOUCHPAD=""; cat /tmp/touchpad_off.tmp; [ $? = 0 ] && TOUCHPAD="  |"

  xsetroot -name "$DESKTOP$TOUCHPAD vol:$VOLUME | bat:$BATTERY | mem:$MEMORY | cpu:$CPU | $TIME"
}

#init bar on script start
STATUSBAR

while :
do
  #every 30 seconds on the minute
  sleep $((60 - $(date +%S) ))
  STATUSBAR
  sleep 30
  STATUSBAR
done

#notes
#         墳 婢 直睊  
#                         
