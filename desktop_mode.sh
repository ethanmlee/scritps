#!/bin/bash
cat /tmp/desktop_mode.tmp; [ $? = 1 ] && touch /tmp/desktop_mode.tmp && refreshbar.sh && exit
cat /tmp/desktop_mode.tmp; [ $? = 0 ] && rm /tmp/desktop_mode.tmp    && refreshbar.sh && exit
