#!/bin/zsh

# before lock

#lock script
MSG=$(fortune -s | cowsay -f turtle) && physlock -mp $MSG

# after lock
echo $(date '+%a %d.%m.%+4Y %I:%M %p %Z') > /tmp/curTime.tmp
refreshbar.sh
doas nmcli networking off && sleep 1 && doas nmcli networking on
autorandr --change
