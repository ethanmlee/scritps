#!/bin/sh

START_TIME=$(date +%s)

while :; do
  STOPWATCH=$(TZ=UTC date --date now-${START_TIME}sec +%H:%M:%S.%N | ( sed 's/.\{7\}$//' || cat ))
  printf "\r%s" "$STOPWATCH"
  sleep 0.03
done
