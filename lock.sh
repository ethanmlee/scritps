#!/bin/zsh

# before lock
dbus-send --print-reply --dest=org.keepassxc.KeePassXC.MainWindow /keepassxc org.keepassxc.MainWindow.lockAllDatabases

#lock script
MSG=$(fortune -s | cowsay -f turtle) && physlock -mp $MSG

# after lock
echo $(date '+%a %d.%m.%+4Y %I:%M %p %Z') > /tmp/curTime.tmp
refreshbar.sh
[ $(cat /sys/class/net/w*/operstate) != "up" ] && nmcli networking off && sleep 1 && nmcli networking on
autorandr --change
