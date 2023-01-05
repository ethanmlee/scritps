#!/bin/sh
cat /tmp/touchpad_off.tmp; [ $? = 1 ] && touch /tmp/touchpad_off.tmp && xinput set-prop "PIXA3854:00 093A:0274 Touchpad" "Device Enabled" 0 && refreshbar.sh && exit
cat /tmp/touchpad_off.tmp; [ $? = 0 ] && rm /tmp/touchpad_off.tmp    && xinput set-prop "PIXA3854:00 093A:0274 Touchpad" "Device Enabled" 1 && refreshbar.sh && exit

