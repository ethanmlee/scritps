#!/bin/sh
wn=$(xdotool getactivewindow getwindowname)
TERMINAL=urxvtcd
case $wn in
  "ssh"*) $TERMINAL -title "$wn" -e $wn ;;
  "zsh"*) $TERMINAL -cd $(echo $wn | cut -d' ' -f2- | sed "s|^~|$HOME|" ) ;;
  *"VIM") $TERMINAL -cd $(echo $wn | sed -E -n 's/.*\((.*)\).*$/\1/p' | sed "s|^~|$HOME|" ) ;;
  *"LibreWolf") $TERMINAL -cd $HOME/dwn ;;
  "spacefm"*) $TERMINAL -cd $(echo $wn | cut -d' ' -f2-) ;;
esac


