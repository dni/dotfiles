#!/usr/bin/env sh
export DOTFILES=/home/dni/dotfiles
export EDITOR="vim"
export TERM="xterm-256color"
export ENV=$DOTFILES/.profile
export PATH=$PATH:$DOTFILES/bin:~/.local/bin
export PATH=$PATH:/home/dni/.gem/ruby/3.0.0/bin # ruby for jekyll blog
export PYTHONPATH=/usr/lib/python3.8/site-packages

export STATUS_INTERVAL="15s"
export STATUS_WEATHER="vienna"

. $DOTFILES/.aliases
. $DOTFILES/.functions

# source potential user configuration, overwriting is possible
if [ -e "$HOME"/.aliases ]; then
  . "$HOME"/.aliases
fi
if [ -e "$HOME"/.functions ]; then
  . "$HOME"/.functions
fi
