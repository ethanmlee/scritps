#!/bin/sh
# Doesn't work needs to be finished
directory="/tmp/qs/"
file="$directory$1"

[ ! -e "$file" ] && \
{
  mkdir -p $directory
  touch "$file"
  echo "#!/bin/sh\n\n" >> "$file"
}

$EDITOR $file
chmod +x $file

echo "Do you want to proceed? (yes/no):"
read answer

answer=$(echo $answer | tr '[:upper:]' '[:lower:]')

[ "$answer" = "y" ] || [ "$answer" = "yes" ] && $file
