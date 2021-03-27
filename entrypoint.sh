#!/usr/bin/env sh

yadm decrypt && yadm pull \
    && git clone git@github.com:${REPO} \
    && cd $(basename $REPO) \
    && tmux new-session \; \
            split-window -v -p 20 \; \
            select-pane -t 0 \; \
            split-window -h -p 40 \; \
            split-window -v -p 60 \; \
            select-pane -t 1 \; \
            send-keys 'htop' C-m \; \
            select-pane -t 0 \; \
            send-keys 'vim .' C-m \;
