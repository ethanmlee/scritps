#!/bin/sh

while true
do
  random_port=$(shuf -i 10000-49152 | head -n 1)
  nc -z 127.0.0.1 $random_port < /dev/null &>/dev/null
  [ $? = 0 ] && echo "$random_port" && exit
done
