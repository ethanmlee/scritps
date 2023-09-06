#!/bin/sh

# Create a named pipe (FIFO)
FIFO=$(mktemp -u) && mkfifo "$FIFO"

acpi_listen > "$FIFO" &
trap 'rm -f "$FIFO"; kill "$!"' EXIT

while read -r event; do
    #event_handler.sh "$event"
    echo "$event"
done < "$FIFO"
