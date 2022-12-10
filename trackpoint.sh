#!/bin/sh
cat /tmp/trackpoint.tmp; [ $? = 1 ] && touch /tmp/trackpoint.tmp && xinput set-prop "Logitech USB-PS/2 Optical Mouse" "Device Enabled" 0 && echo "trackpoint off" && exit
cat /tmp/tackpoint.tmp; [ $? = 0 ] && rm /tmp/trackpoint.tmp && xinput set-prop "Logitech USB-PS/2 Optical Mouse" "Device Enabled" 1 && echo "trackpoint on" && exit

