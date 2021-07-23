#!/usr/bin/env sh
while read -r x; do
  . "$DOTFILES"/"$x"
  test -r ~/"$x" && . ~/"$x"
done <<EOF
.env
.aliases
.functions
EOF
