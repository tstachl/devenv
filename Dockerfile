FROM alpine:latest
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

ENV TZ="America/Los_Angeles" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8"

RUN apk update && apk upgrade --prune && \
    apk add \
      tzdata musl-locales musl-locales-lang \
      sudo curl openssh docker g++ npm \
      chezmoi age fish git neovim tmux htop github-cli \
    && \
    cp /usr/share/zoneinfo/America/Los_Angeles /etc/localtime && \
    echo "America/Los_Angeles" >  /etc/timezone && \
    apk del tzdata \
    && \
    adduser -D -s $(which fish) thomas && \ 
    echo "thomas ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/thomas && \
    chmod 0440 /etc/sudoers.d/thomas \
    && \
    echo "setup completed"

ENV REPO=tstachl/devenv \
    TERM=xterm-256color \
    EDITOR=nvim \
    SHELL=/usr/bin/fish
USER thomas
SHELL ["/usr/bin/fish", "-c"]

COPY entrypoint.fish /usr/local/bin
RUN sudo chmod a+x /usr/local/bin/entrypoint.fish && \
    mkdir ~/.ssh && touch ~/.ssh/known_hosts && \
    echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts && \
    chezmoi init --verbose https://github.com/tstachl/chezmoi 

RUN chezmoi apply ~/.config/fish && chezmoi apply ~/.config/nvim && \
    nvim --headless -c "autocmd User PackerComplete quitall" && \
    source ~/.config/fish/config.fish && \
    echo "configuration completed"

WORKDIR /home/thomas/workspace
CMD ["entrypoint.fish"]

