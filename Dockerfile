FROM debian:bullseye-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

COPY entrypoint.sh /usr/local/bin
RUN apt-get update -y && apt-get full-upgrade -y \
    && apt-get install -y git zsh vim tmux sudo htop curl gpg \
    && bash -c "$(curl -sSL https://get.docker.com/)" \
    && useradd -p $(openssl passwd -crypt password) -ms /usr/bin/zsh thomas \
    && usermod -a -G sudo thomas \
    && su - thomas \
    && sudo usermod -aG docker thomas \
    && sudo systemctl enable docker.service \
    && sudo systemctl enable containerd.serice \
    && cd ~ \
    && sudo curl -fLo /usr/local/bin/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm \
    && sudo chmod a+x /usr/local/bin/yadm \
    && sudo chmod a+x /usr/local/bin/entrypoint.sh

ENV REPO=tstachl/devenv TERM=xterm-256color EDITOR=vim SHELL=/usr/bin/zsh
USER thomas

SHELL ["/usr/bin/zsh", "-c"]

RUN mkdir ~/.ssh && touch ~/.ssh/known_hosts \
    && echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts \
    && yadm clone https://github.com/tstachl/dotfiles.git --bootstrap \
    && source ~/.zshrc \
    && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm \
    && ~/.tmux/plugins/tpm/bin/install_plugins \
    && mkdir ~/workspace \
    && echo "All Done"

WORKDIR /home/thomas/workspace

CMD entrypoint.sh


