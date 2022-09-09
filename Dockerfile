FROM  alpine:latest AS base
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

ARG USER="thomas" \
    YADM="https://github.com/tstachl/dotfiles.git"

# currently we're still using bash to make yadm work
ENV TZ="America/Los_Angeles" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    REPO="tstachl/devenv" \
    EDITOR="nvim" \
    SHELL="/bin/bash"

# Install required software and add the user
RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" \
      >> /etc/apk/repositories && \
    echo "@community https://dl-cdn.alpinelinux.org/alpine/edge/community" \
      >> /etc/apk/repositories && \
    apk update && apk upgrade --prune && \
    apk add \
      git bash neovim@community sudo curl gnupg docker openssh zig@testing && \
    \
    ssh-keyscan -H github.com >> /etc/ssh/ssh_known_hosts && \
    \
    curl -fLo /usr/local/bin/yadm \
      https://github.com/TheLocehiliosan/yadm/raw/master/yadm && \
    chmod a+x /usr/local/bin/yadm && \
    \
    adduser -D -s $(which bash) $USER && \ 
    echo "${USER} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER && \
    chmod 0440 /etc/sudoers.d/$USER

COPY files/bash/xdg.sh /etc/profile.d
COPY files/bash/bash_logout /etc/bash
COPY files/entrypoint.sh /usr/local/bin/entrypoint.sh

USER $USER
SHELL ["/bin/bash", "--login", "-c"]

# Clone and bootstrap dotfiles
RUN yadm clone $YADM

WORKDIR /home/$USER/workspace
CMD "/usr/local/bin/entrypoint.sh"

FROM base AS rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

FROM base as node
RUN sudo apk add yarn

