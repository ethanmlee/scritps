#!/bin/sh
xrdb -load ~/.Xresources
kill -1 $(pidof urxvtd) & kill -1 $(pidof urxvt) &
