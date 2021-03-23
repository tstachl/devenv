FROM debian:bullseye-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

RUN apt-get update -y && apt-get full-upgrade -y \
    && apt-get install -y git zsh vim tmux sudo curl \
    && useradd -p $(openssl passwd -crypt password) -ms /usr/bin/zsh thomas \
    && usermod -a -G sudo thomas \
    && su - thomas \
    && cd ~ \
    && sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
    && sudo chmod a+x /usr/local/bin/yadm 

USER thomas
WORKDIR /home/thomas

ENV REPO=tstachl/devenv
CMD yadm clone https://github.com/tstachl/dotfiles.git \
    && yadm decrypt \
    && git clone git@github.com:${REPO} \
    && cd $(basename $REPO) \
    && zsh