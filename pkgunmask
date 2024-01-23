#!/bin/sh

# Require root privleges
if [ "$(id -u)" != "0" ]; then
    echo "This script requires root privileges."
    echo "Please run this script with root priveleges."
    exit 1
fi

emerge $@ --autounmask-write --autounmask
etc-update
emerge -a $@
