#!/usr/bin/env bash

# For each Ruby file changed in this branch
git d dev --name-only | grep '.rb' | xargs rubocop | grep '^[^ ].*:[0-9]' | while read line
do
  # Files and lines that rubocop does not like
  file=$(echo "$line" | cut -f 1 -d:)
  file_line=$(echo "$line" | cut -f 2 -d:)
  msg=$(echo "$line" | cut -f 2- -d' ')

  # Commit which created the mess
  hash=$(git blame -p $file -L $file_line,+1 | cut -f 1 -d' ' | head -n 1)

  # Select the commit if it was added in this branch
  if git log --pretty=oneline dev..@ | cut -f 1 -d' ' | grep -q "$hash"
  then
    echo "$hash $file:$file_line $msg"
  fi
done
