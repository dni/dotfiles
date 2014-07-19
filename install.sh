ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
brew doctor
brew bundle Brewfile
brew bundle Cakefile

cp -r bundle ~/.vim/
cp .vimrc ~/

