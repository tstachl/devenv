FROM debian:bullseye-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

RUN apt-get update -y && apt-get full-upgrade -y \
    && apt-get install -y git zsh vim tmux sudo \
    && useradd -ms /usr/bin/zsh thomas \
    && usermod -a -G sudo thomas
USER thomas
ENV REPO=tstachl/devenv
CMD git checkout git@github.com:${REPO} && cd $(basename $REPO)