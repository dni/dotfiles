#!/bin/zsh
ZSH_THEME="candy"
plugins=(aws vagrant composer)
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

export DOTFILES=/home/dni/dotfiles
source $DOTFILES/.profile

# enable vi mode
# bindkey -v
