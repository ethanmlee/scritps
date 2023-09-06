#!/bin/bash
cd ${0%/*}

BG=$(xrdb -query | grep background: | cut -f 2 | head -n1)
FG=$(xrdb -query | grep foreground: | cut -f 2 | head -n1)

WIDTH=$(echo "$(xdpyinfo | grep dimensions | awk '{print $2}' | sed "s/x.*//" | tr -d '\n') - $(xrdb -query | grep 'dwm.gappih' | awk '{print $2}') * 2" | bc)

HEIGHT=30

# Terminate already running bar instances
killall -q lemonbar

# Wait until the processes have been shut down
if pgrep '^lemonbar' > /dev/null; then
  exit 0
fi

echo "hello world" | lemonbar -p -g "$WIDTH"x"$HEIGHT" -f "xft:Hack Nerd Font Mono:antialias=true:hinting=true:size=9" -B "$BG" -F "$FG" &
