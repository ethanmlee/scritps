#!/bin/sh
# loop through all open windows (ids)
for win_id in $( wmctrl -l | cut -d' ' -f1 ); do
  # test if window is a normal window
  xprop -id $win_id _NET_WM_WINDOW_TYPE | grep -q _NET_WM_WINDOW_TYPE_NORMAL
  [ $? = 0 ] && xpid=$(xprop -id $win_id _NET_WM_PID | cut -d" " -f3-)
  kill -44 $xpid
done

kill -44 $(pgrep -f code)
kill -44 $(pgrep -f dwmbar.sh)
kill $(pgrep -f urxvt)
