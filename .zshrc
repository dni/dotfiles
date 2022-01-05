#!/bin/zsh
ZSH_THEME="candy"
plugins=(aws vagrant composer)
export ZSH=~/.oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/dotfiles/.profile

PATH=$PATH:~/.local/share/gem/ruby/3.0.0/bin

if [ -d "$HOME/adb-fastboot/platform-tools" ] ; then
 export PATH="$HOME/adb-fastboot/platform-tools:$PATH"
fi

# zsh aliases
alias -g G='| grep'
alias -g M='| more'
alias -g L='| less'
alias -g J='| jq'


# enable vi mode
# bindkey -v
