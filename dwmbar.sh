#!/bin/sh

BACKGROUND=$(xrdb -query | grep background: | cut -f 2 | head -n1)
COL1=$(xrdb -query | grep color1: | cut -f 2)
COL3=$(xrdb -query | grep color3: | cut -f 2)
COL6=$(xrdb -query | grep color6: | cut -f 2)

STATUSBAR() {
  # Time
  # dynamically set timezone?
  TIME=" $(date '+%a, %b %d, %4Y %I:%M%P %Z')"

  # Volume
  # remember last volume value when muted
  MIC=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk  '{print $2}')
  [ $MIC = "yes" ] && MIC="" || MIC="^c#ed1b23^  ^d^│"


  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5;}' | sed 's/.$//')
  MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  [ $VOLUME = 0 ] &&  VOLICON=
  [ $VOLUME -gt 0 ] && VOLICON=" "
  [ $VOLUME -ge 50 ] && VOLICON=" 墳"
  [ $VOLUME -gt 100 ] && VOLICON="^c#ed1b23^ !墳"
  [ $MUTE = "yes" ] && VOLICON=" 婢"
  VOLUME="$MIC$VOLICON $VOLUME% ^d^"

  # Battery
  #         
  CAPACITY=$(cat /sys/class/power_supply/BAT?/capacity)
  if [ -z $CAPACITY ]; then
    BATTERY=""
  else
    [ $CAPACITY -ge  0 ] && CHARGE= && BATCOL="^c$BACKGROUND^^b$COL1^"
    [ $CAPACITY -ge 10 ] && CHARGE= && BATCOL="^c$COL1^"
    [ $CAPACITY -ge 30 ] && CHARGE= && BATCOL="^c$COL3^"
    [ $CAPACITY -ge 40 ] && CHARGE= && BATCOL=""
    [ $CAPACITY -ge 60 ] && CHARGE= && BATCOL=""
    [ $CAPACITY -ge 80 ] && CHARGE= && BATCOL=""
    [ $CAPACITY -gt 90 ] && CHARGE= && BATCOL=""
    UPOWER=$(cat /sys/class/power_supply/BAT*/status)
    [ "$UPOWER" = "Charging" ] && CHARGE="^c$COL6^" && BATCOL=""
    BATTERY="│$BATCOL $CHARGE $CAPACITY% ^d^"
  fi

  # Internet
  #  
  if grep -xq 'up' /sys/class/net/w*/operstate 2>/dev/null; then
    NET=" $(awk '/^\s*w/ { print "說", int($3 * 100 / 70) "%" }' /proc/net/wireless) "
  elif grep -xq 'down' /sys/class/net/w*/operstate 2>/dev/null; then
    grep -xq '0x1003' /sys/class/net/w*/flags && NET=" 說 " || NET=" ! "
  fi
  [ $(cat /sys/class/net/e*/operstate) = "up" ] && NET="  "

  # Memory
  MEMORY="  $(free -h | grep 'Mem' | awk '{ print $3 }') "

  # CPU TEMP
  #     
  CPU=$(sensors coretemp-isa-0000 -u | grep temp1_input | awk '{ print $2 }' | sed 's/\..*//g')
  [ $CPU -ge  0 ] && CPUICON=" "
  [ $CPU -gt 45 ] && CPUICON=" "
  [ $CPU -gt 60 ] && CPUICON=" "
  [ $CPU -gt 65 ] && CPUICON=" "
  [ $CPU -gt 75 ] && CPUICON="^c$COL1^ !"
  CPU="$CPUICON $CPU°C ^d^"

  # toggle indicators
  # setup indicatiors object and combine everything here
  DESKTOP="";  cat /tmp/desktop_mode.tmp; [ $? = 0 ] && DESKTOP=" ^c$COL3^^d^ │"
  TOUCHPAD=""; cat /tmp/touchpad_off.tmp; [ $? = 0 ] && TOUCHPAD="  │"


  # XSETROOT
  xsetroot -name "$DESKTOP$TOUCHPAD$VOLUME$BATTERY│$MEMORY│$CPU│$NET│$TIME"
}

#init bar on script start
STATUSBAR

while :
do
  t=15
  sleep $(($t - $(date +%s) % $t))
  STATUSBAR
done
