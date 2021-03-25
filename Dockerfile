FROM debian:bullseye-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

RUN apt-get update -y && apt-get full-upgrade -y \
    && apt-get install -y git zsh vim tmux sudo curl gpg \
    && useradd -p $(openssl passwd -crypt password) -ms /usr/bin/zsh thomas \
    && usermod -a -G sudo thomas \
    && su - thomas \
    && cd ~ \
    && sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
    && sudo chmod a+x /usr/local/bin/yadm 

ENV REPO=tstachl/devenv TERM=xterm-256color EDITOR=vim SHELL=/usr/bin/zsh
USER thomas
WORKDIR /home/thomas

SHELL ["/usr/bin/zsh", "-c"]

RUN yadm clone https://github.com/tstachl/dotfiles.git --bootstrap \
    && source ~/.zshrc \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && ~/.tmux/plugins/tpm/bin/install_plugins \
    && echo "All Done"

CMD yadm decrypt && yadm pull \
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


