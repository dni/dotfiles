#!/usr/bin/env sh
while read -r x; do
  . "$DOTFILES"/"$x"
  test -r "$HOME"/"$x" && . "$HOME"/"$x"
done <<EOF
.env
.aliases
.functions
EOF
