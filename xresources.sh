#!/bin/sh
xrdb -load ~/.Xresources
kill -1 $(pidof urxvtd)
kill -1 $(pidof urxvt)
#refreshbar.sh
polybar.sh
sleep 1 && dwm-msg run_command quit
sleep 1 && \
dwm-msg run_command togglebar 0 && \
dwm-msg run_command togglebar 0 &


