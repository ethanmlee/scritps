#!/bin/sh
[ -z $@ ] && echo "specify file to share or let someone upload to -U" && exit
PORT=$(port.sh)

lt -p $PORT > /tmp/ltlink.tmp &
trap 'kill -44 $(pgrep -f lt) 2> /dev/null & rm /tmp/ltlink.tmp' EXIT

[ -f "$PWD/$@" ] && SHARE=f && sleep 1 && echo "/$@" >> /tmp/ltlink.tmp
[ -d "$PWD/$@" ] && SHARE=d && sleep 1 && echo "/$@.zip" >> /tmp/ltlink.tmp
[ -z $SHARE ] && echo "\"$@\" is not a file or directory" && exit

# echos full link and copies to clipboard
tr -d '\n' < /tmp/ltlink.tmp | sed 's/.*: //' | xclip -selection c
tr -d '\n' < /tmp/ltlink.tmp && echo
echo "link copied to clipboard"

woof -i 127.0.0.1 -Z -p $PORT $@ > /dev/null &
trap 'kill -44 $(pgrep -f woof) 2> /dev/null' INT

# wait until woof stops to close script
while :
do
  pgrep -f woof > /dev/null; [ $? = 1 ] && exit
  sleep 0.5
done
