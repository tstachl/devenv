#!/usr/bin/env bash

if yadm decrypt; then
  yadm pull

  if [ -d "$REPO" ]; then
    cd $REPO && git pull
  else
    git clone git@github.com:$REPO $REPO && cd $REPO
  fi

  clear
  exec bash
fi

echo "Not allowed to use this."
exit

