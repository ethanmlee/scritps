#!/bin/sh


STATUSBAR() {
  # Time
  # dynamically set timezone?
  TIME="$(date '+%a, %b %d, %4Y %I:%M%P %Z')"

  # Volume
  # remember last volume value when muted
  MIC=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk  '{print $2}')
  [ $MIC = "yes" ] && MIC="" || MIC="  │ "


  VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | head -1 | awk '{print $5;}' | sed 's/.$//')
  MUTE=$(pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}')
  [ $VOLUME = 0 ] &&  VOLICON=""
  [ $VOLUME -gt 0 ] && VOLICON=""
  [ $VOLUME -ge 50 ] && VOLICON="墳"
  [ $VOLUME -gt 100 ] && VOLICON="!墳"
  [ $MUTE = "yes" ] && VOLICON="婢"
  VOLUME="$MIC$VOLICON $VOLUME%"

  xsetroot -name "$VOLUME | $TIME "
}

STATUSBAR
while :
do
  t=15
  sleep $(($t - $(date +%s) % $t))
  STATUSBAR
done
