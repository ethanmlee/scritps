#!/bin/sh
cd ~/mdn
FILE=$(/home/ethan/git/fzf/bin/fzf --preview 'bat --style=numbers --color=always --line-range :500 {}' --preview-window=right:70%:wrap)
[ $? = 0 ] && vim $FILE
