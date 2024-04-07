#!/bin/sh
cat /tmp/desktop_mode.tmp; [ $? = 1 ] && touch /tmp/desktop_mode.tmp && exit
cat /tmp/desktop_mode.tmp; [ $? = 0 ] && rm /tmp/desktop_mode.tmp    && exit
