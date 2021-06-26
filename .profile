#!/usr/bin/env sh
export DOTFILES=/home/dni/dotfiles
export EDITOR="vim"
export TERM="xterm-256color"
export ENV=$DOTFILES/.profile
export PATH=$PATH:$DOTFILES/bin:~/.local/bin
export PYTHONPATH=/usr/lib/python3.8/site-packages

. $DOTFILES/.aliases
. $DOTFILES/.functions
