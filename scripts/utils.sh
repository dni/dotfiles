#!/usr/bin/env sh

# this function is for testing and debugging, also mentioned in my blog post
hello() {
  echo "hello world! you are running a"
  case $- in
    *i*) echo "interactive";;
    *) echo "non-interactive";;
  esac
  # sh has no 100% reliable way to tell if its a login shell,
  # but checking if you are in tty is pretty close
  tty | grep -q "tty" && echo "tty / (?)login shell" || echo "non-login shell"
}

get_functions() {
  retval=$(sh -ic "declare -F" | sed "s/declare -f//g")
  echo "$retval"
}

# populate ./bin/ with symlink to the magic run_function script
create_binaries() {
  rm "$DOTFILES"/bin/*
  get_functions | while read -r x; do
    ln -sf "$DOTFILES"/scripts/run_function "$DOTFILES"/bin/"$x"
  done
}


check_update() {
  sudo pacman -Sy
  sudo pacman -Qu | wc -l > $HOME/.cache/updates
  dunstify "$(cat $HOME/.cache/updates) updates available"
}

screenshot() {
  maim -s ~/Screenshots/screenshot-"$(date +%s)".jpg
}

upload() {
  [ -n "$1" ] || echo "$1" doesnt exist.
  [ -n "$1" ] || return
  aws s3 cp "$1" s3://dnilabs-hostinghelden/upload/
  echo "https://d261tqllhzwogc.cloudfront.net/upload/$1"
}

# just for testing nesting :)
# before running nesting_test all function inside are undefined
nesting_test(){
  echo "define nest1"
  nest1() {
    echo "define inside, inside nest1"
    inside() {
      echo "inside nest1"
    }
    echo "execute inside, inside nest1"
    inside
  }
  echo "define nest2"
  nest2() {
    echo "define inside2"
    inside2() {
      echo "inside2 nest2"
    }
    echo "define inside"
    inside() {
      echo "inside nest2"
    }
    echo "execute inside, inside nest2"
    inside
  }
  echo "define nest3"
  nest3() {
    echo "define inside3"
    inside3() {
      echo "inside nest3"
    }
  }
  echo "executing nest1()"
  nest1
  echo "executing inside()"
  inside
  echo "executing nest2()"
  nest2
  echo "executing inside()"
  inside
  echo "executing inside2()"
  inside2
  echo "not executing nest3()"
  echo "executing inside3() will fail"
  inside3
  echo "all functions still are defined"
}
