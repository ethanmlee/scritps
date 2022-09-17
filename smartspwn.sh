#!/bin/sh
wn=$(xdotool getactivewindow getwindowname)
case $wn in
  "ssh"*) urxvtcd -title "$wn" -e $wn ;;
  "urxvt"*) urxvtcd -cd $(echo $wn | cut -d' ' -f2- | sed "s|^~|$HOME|" ) ;;
  *"VIM") urxvtcd -cd $(echo $wn | sed -E -n 's/.*\((.*)\).*$/\1/p' | sed "s|^~|$HOME|" ) ;;
  *"LibreWolf") urxvtcd -cd $HOME/dwn ;;
  "spacefm"*) urxvtcd -cd $(echo $wn | cut -d' ' -f2-) ;;
esac


