FROM debian:bullseye-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

COPY entrypoint.sh /usr/local/bin
RUN apt-get update -y && apt-get full-upgrade -y \
    && apt-get install -y git zsh vim tmux sudo htop curl gpg \
    && useradd -p $(openssl passwd -crypt password) -ms /usr/bin/zsh thomas \
    && usermod -a -G sudo thomas \
    && su - thomas \
    && cd ~ \
    && sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
    && sudo chmod a+x /usr/local/bin/yadm \
    && sudo chmod a+x /usr/local/bin/entrypoint.sh

ENV REPO=tstachl/devenv TERM=xterm-256color EDITOR=vim SHELL=/usr/bin/zsh
USER thomas

SHELL ["/usr/bin/zsh", "-c"]

RUN yadm clone https://github.com/tstachl/dotfiles.git --bootstrap \
    && source ~/.zshrc \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && ~/.tmux/plugins/tpm/bin/install_plugins \
    && mkdir ~/workspace \
    && echo "All Done"

WORKDIR /home/thomas/workspace

CMD entrypoint.sh


