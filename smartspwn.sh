#!/bin/sh
wn=$(xdotool getactivewindow getwindowname)
TERMINAL=urxvtcd
case $wn in
  "("*")"*) $TERMINAL -e ssh -t $(echo $wn | awk -F"[()]" '{print $2}') "cd $(echo $wn | awk '{print $3}') ; zsh" ;; 
  "ssh"*) $TERMINAL -title "$wn" -e $wn ;;
  "zsh"*) $TERMINAL -cd $(echo $wn | cut -d' ' -f2- | sed "s|^~|$HOME|" ) ;;
  *"VIM") $TERMINAL -cd $(echo $wn | sed -E -n 's/.*\((.*)\).*$/\1/p' | sed "s|^~|$HOME|" ) ;;
  *"Mozilla Firefox") $TERMINAL -cd $HOME/dwn ;;
  #"spacefm"*) $TERMINAL -cd $(echo $wn | cut -d' ' -f2-) ;;
esac


