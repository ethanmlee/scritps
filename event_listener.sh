#!/bin/sh

# Create a named pipe (FIFO)
FIFO=$(mktemp -u) && mkfifo "$FIFO"

acpi_listen > "$FIFO" &
trap 'rm -f "$FIFO"; kill "$!"' EXIT

while read -r event; do
    set -- $event
    event_handler.sh "$@"
    echo "$event"
done < "$FIFO"
