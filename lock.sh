#!/bin/sh
MSG=$(fortune -s | cowsay -f turtle) && physlock -mp "$MSG"
autorandr --change
exit
