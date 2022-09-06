#!/usr/bin/env bash

if yadm pull && yadm bootstrap && yadm decrypt; then

  if [ -d "$REPO" ]; then
    cd $REPO && git pull
  else
    git clone git@github.com:$REPO $REPO && cd $REPO
  fi

  clear
  exec bash --login
fi

echo "Not allowed to use this."
exit
