#!/usr/bin/env sh
# .env should hold all enviroment variable
# .functions should hold all functions
# .alias should hold all aliases
# also we source potential user configuration, so overwriting is possible
export DOTFILES=/home/dni/dotfiles
while read -r x; do
  . "$DOTFILES"/"$x"
  [ -e "$HOME"/"$x" ] && . "$HOME"/"$x"
done <<EOF
.env
.aliases
.functions
EOF
