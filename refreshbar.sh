#!/bin/sh

kill -44 $(pgrep -f dwmbar.sh) # kills dwmbar.sh
nohup dwmbar.sh > /dev/null & exit # starts dwmbar.sh
