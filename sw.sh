#!/bin/sh
# todo:
# - option to write to file (both "enter" times and final time)
# - make more efficent and faster (though this may be bottlenecked by terminal)

START_TIME=$(date +%s)

while :; do
  STOPWATCH=$(TZ=UTC date --date now-${START_TIME}sec +%H:%M:%S.%N | ( sed 's/.\{7\}$//' || cat ))
  printf "\r%s" "$STOPWATCH"
  sleep 0.03
done
