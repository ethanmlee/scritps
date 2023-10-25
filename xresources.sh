#!/bin/sh
# reload .Xresources
xrdb -load ~/.Xresources

# urxvt-config-reload
# https://github.com/regnarg/urxvt-config-reload
kill -1 $(pidof urxvtd)
kill -1 $(pidof urxvt)

# restart polybar
polybar.sh

# restart dwm (doesn't quick bc dwm is running in loop)
sleep 1 && dwm-msg run_command quit

# Polybar dwm gaps bug workaround
sleep 2 && \
dwm-msg run_command togglebar 0 && \
dwm-msg run_command togglebar 0 &
