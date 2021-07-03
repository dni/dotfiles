#!/bin/zsh
ZSH_THEME="candy"
plugins=(aws vagrant composer)
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/dotfiles/.profile

PATH=$PATH:~/.local/share/gem/ruby/3.0.0/bin

# enable vi mode
# bindkey -v
