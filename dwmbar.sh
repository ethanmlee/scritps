#!/bin/sh

STATUSBAR() {
  # Time
  # dynamically set timezone?
  TIME=$(date '+%a, %b %d, %4Y %I:%M%P %Z')

  # Volume
  # remember last volume value when muted
  MIC=$(pamixer --source alsa_input.pci-0000_00_1f.3.analog-stereo --get-volume-human)
  [ $MIC = "muted" ] && MIC="" || MIC="^c#ed1b23^  ^d^│"


  VOLUME=$(pamixer --get-volume-human | sed 's/.$//')
  [ $VOLUME = 0 ] &&  VOLICON=
  [ $VOLUME != "mute" ] && [ $VOLUME -gt  0 ] && [ $VOLUME -lt  50 ] && VOLICON=" "
  [ $VOLUME != "mute" ] && [ $VOLUME -ge 50 ] && VOLICON=" 墳"
  [ $VOLUME != "mute" ] && [ $VOLUME -gt 100 ] && VOLICON="^c#ed1b23^ !墳"
  [ $VOLUME != "mute" ] && VOLUME="$MIC$VOLICON $VOLUME% ^d^"
  [ $VOLUME =  "mute" ] && VOLUME="$MIC 婢 "

  # Battery
  #         
  CAPACITY=$(cat /sys/class/power_supply/BAT?/capacity)
  [ $CAPACITY -gt 90 ] && [ $CAPACITY -le 100 ] && CHARGE= #&& BATCOL="^c#000000^^b#55fa55^"
  [ $CAPACITY -ge 80 ] && [ $CAPACITY -lt  90 ] && CHARGE= #&& BATCOL="^c#000000^^b#55fa55^"
  [ $CAPACITY -ge 60 ] && [ $CAPACITY -lt  80 ] && CHARGE=
  [ $CAPACITY -ge 40 ] && [ $CAPACITY -lt  60 ] && CHARGE=
  [ $CAPACITY -ge 30 ] && [ $CAPACITY -lt  40 ] && CHARGE= && BATCOL="^c#fafa46^"
  [ $CAPACITY -ge 10 ] && [ $CAPACITY -lt  30 ] && CHARGE= && BATCOL="^c#ed1b23^"
  [ $CAPACITY -ge  0 ] && [ $CAPACITY -lt  10 ] && CHARGE= && BATCOL="^c#000000^^b#ed1b23^"
  UPOWER=$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -E "state" | awk '{ print $NF }')
  [ "$UPOWER" = "charging" ] || [ "$UPOWER" = "fully-charged" ] && CHARGE="^c#46e8fa^" && BATCOL=""
  BATTERY="$BATCOL $CHARGE $CAPACITY% ^d^"

  # Internet
  #  

  if grep -xq 'up' /sys/class/net/w*/operstate 2>/dev/null; then
    NET="$(awk '/^\s*w/ { print "說", int($3 * 100 / 70) "%" }' /proc/net/wireless)"
  elif grep -xq 'down' /sys/class/net/w*/operstate 2>/dev/null; then
    grep -xq '0x1003' /sys/class/net/w*/flags && NET="說" || NET="!"
  fi
  [ $(cat /sys/class/net/e*/operstate) = "up" ] && NET=""

  # Memory
  MEMORY=" $(free -h | grep 'Mem' | awk '{ print $3 }')"

  # CPU
  #     
  CPU=$(sensors acpitz-acpi-0 -u | grep temp1_input | awk '{ print $2 }' | sed 's/\..*//g')
  [ $CPU -gt  0 ] && [ $CPU -le 45 ] && CPUICON=" "
  [ $CPU -gt 45 ] && [ $CPU -le 60 ] && CPUICON=" "
  [ $CPU -gt 60 ] && [ $CPU -le 65 ] && CPUICON=" "
  [ $CPU -gt 65 ] && [ $CPU -le 75 ] && CPUICON=" "
  [ $CPU -gt 75 ] && CPUICON="^c#ed1b23^ !"
  CPU="$CPUICON $CPU°C ^d^"

  # toggle indicators
  # hack  
  # setup indicatiors object and combine everything here
  DESKTOP="";  cat /tmp/desktop_mode.tmp; [ $? = 0 ] && DESKTOP=" ^c#fafa46^^d^ │"
  TOUCHPAD=""; cat /tmp/touchpad_off.tmp; [ $? = 0 ] && TOUCHPAD="  │"


  # XSETROOT
  xsetroot -name "$DESKTOP$TOUCHPAD$VOLUME│$BATTERY│ $MEMORY │$CPU│ $NET │ $TIME"
}

#init bar on script start
STATUSBAR

while :
do
  t=15
  sleep $(($t - $(date +%s) % $t))
  STATUSBAR
done
