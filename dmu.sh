#!/bin/sh
# DMenu Utility
# combines dmenu and dmenu_run into one command and sets colors and gaps from 
# .Xresources. prob a better way to do it but this works for now


FONT=$(xrdb -query | grep 'dwm.dmenufont' | cut -f2)
GAP=$(xrdb -query | grep 'dwm.gappih' | cut -f2)
# monitor width-gap to set width of dmenu
WIDTH=$(echo "$(xdpyinfo | grep dimensions | awk '{print $2}' | sed "s/x.*//" | tr -d '\n') - $GAP * 2" | bc)

# colors
NB=$(xrdb -query | grep 'dwm.normbgcol' | cut -f2)
NF=$(xrdb -query | grep 'dwm.normfgcol' | cut -f2)
SB=$(xrdb -query | grep 'dwm.selbgcol' | cut -f2)
SF=$(xrdb -query | grep 'dwm.selfgcol' | cut -f2)

[ "$1" = "-S" ] && CMD="dmenu" || CMD="dmenu_run"
[ -n "$*" ] && shift

# run command
$CMD $@     \
-m 0        \
-x $GAP     \
-y $GAP     \
-z $WIDTH   \
-h 30       \
-fn "$FONT" \
-nb $NB     \
-nf $NF     \
-sb $SB     \
-sf $SF
