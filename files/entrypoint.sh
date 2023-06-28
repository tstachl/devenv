#!/usr/bin/env bash

if [ -d "$REPO" ]; then
  cd $REPO && git pull
else
  git clone git@github.com:$REPO $REPO && cd $REPO
fi

clear
exec fish --login
