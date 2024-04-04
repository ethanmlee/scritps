#!/bin/sh

d=$(find /etc/portage -type f -size +0c ! -path "/etc/portage/savedconfig/*")

for i in $d
do
  echo "## $i"
  echo "\`\`\`"
  cat "$i"
  echo "\`\`\`"
  echo "\n"
done
