#!/bin/sh

STATUSBAR() {
  # Time
  # dynamically set timezone?
  TIME=$(date '+%a, %b %d, %4Y %I:%M%P %Z')

  # Volume
  # remember last volume value when muted
  # 墳奄奔ﱝ 婢 ⚠
  VOLUME=$(pamixer --get-volume-human | sed 's/.$//')
  [ $VOLUME = 0 ] &&  VOLICON=奄
  [ $VOLUME != "mute" ] && [ $VOLUME -gt  0 ] && [ $VOLUME -lt  50 ] && VOLICON=奔
  [ $VOLUME != "mute" ] && [ $VOLUME -ge 50 ] && VOLICON=墳
  [ $VOLUME != "mute" ] && VOLUME="$VOLICON $VOLUME%"
  [ $VOLUME =  "mute" ] && VOLUME=婢

  # Battery
  #         
  CAPACITY=$(cat /sys/class/power_supply/BAT?/capacity)
  [ $CAPACITY -ge  0 ] && [ $CAPACITY -lt  10 ] && CHARGE=
  [ $CAPACITY -ge 10 ] && [ $CAPACITY -lt  20 ] && CHARGE=
  [ $CAPACITY -ge 20 ] && [ $CAPACITY -lt  40 ] && CHARGE=
  [ $CAPACITY -ge 40 ] && [ $CAPACITY -lt  60 ] && CHARGE=
  [ $CAPACITY -ge 60 ] && [ $CAPACITY -lt  80 ] && CHARGE=
  [ $CAPACITY -ge 80 ] && [ $CAPACITY -lt  90 ] && CHARGE=
  [ $CAPACITY -ge 90 ] && [ $CAPACITY -le 100 ] && CHARGE=
  UPOWER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{ print $NF }')
  [ "$UPOWER" = "charging" ] || [ "$UPOWER" = "fully-charged" ] && CHARGE=
  BATTERY="$CHARGE $CAPACITY%"

  # Internet
  # 直睊
  [ $(cat /sys/class/net/w*/operstate) = "up" ] && NET=直
  [ $(cat /sys/class/net/w*/operstate) = "down" ] && NET=睊

  # Memory
  MEMORY=" $(free -h | grep 'Mem' | awk '{ print $3 }')"

  # CPU
  #     
  CPU=$(sensors acpitz-acpi-0 -u | grep temp1_input | awk '{ print $2 }' | sed 's/\..*//g')
  [ $CPU -gt  0 ] && [ $CPU -le 55 ] && CPUICON=
  [ $CPU -gt 55 ] && [ $CPU -le 60 ] && CPUICON=
  [ $CPU -gt 60 ] && [ $CPU -le 65 ] && CPUICON=
  [ $CPU -gt 65 ] && [ $CPU -le 75 ] && CPUICON=
  [ $CPU -gt 75 ] && CPUICON=
  CPU="$CPUICON $CPU°C"

  # toggle indicators
  # setup indicatiors object and combine everything here
  DESKTOP="";  cat /tmp/desktop_mode.tmp; [ $? = 0 ] && DESKTOP="  |"
  TOUCHPAD=""; cat /tmp/touchpad_off.tmp; [ $? = 0 ] && TOUCHPAD="  |"


  # XSETROOT
  xsetroot -name "$DESKTOP$TOUCHPAD $VOLUME │ $BATTERY │ $MEMORY │ $CPU │ $NET │ $TIME"
}

#init bar on script start
STATUSBAR

while :
do
  sleep $((60 - $(date +%S) ))
  STATUSBAR

done

#notes
#   
