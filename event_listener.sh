#!/bin/bash
coproc acpi_listen
trap 'kill $!' EXIT

while read -u "${COPROC[0]}" -a event; do
  event_handler.sh "${event[@]}"
  #echo "${event[@]}"
done
