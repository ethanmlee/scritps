#!/bin/sh
cat /tmp/trackpoint.tmp; [ $? = 1 ] && touch /tmp/trackpoint.tmp && xinput set-prop "TPPS/2 IBM TrackPoint" "Device Enabled" 0 && echo "trackpoint off" && exit
cat /tmp/tackpoint.tmp; [ $? = 0 ] && rm /tmp/trackpoint.tmp && xinput set-prop "TPPS/2 IBM TrackPoint" "Device Enabled" 1 && echo "trackpoint on" && exit

