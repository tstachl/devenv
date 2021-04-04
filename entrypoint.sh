#!/usr/bin/env bash

yadm decrypt && yadm pull

if [[ ! -f "$HOME/.docker/config.json" ]]; then
  echo "You're not allowed to continue."
  exit
fi

dir=$(basename $REPO)

if [ -d "$dir" ]; then
  cd $dir && git pull
else
  git clone git@github.com:${REPO} && cd $dir
fi

tmux new-session \; \
  split-window -v -p 20 \; \
  select-pane -t 0 \; \
  split-window -h -p 40 \; \
  split-window -v -p 60 \; \
  select-pane -t 1 \; \
  send-keys 'htop' C-m \; \
  select-pane -t 0 \; \
  send-keys 'vim .' C-m \;
