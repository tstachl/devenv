FROM  debian:testing-slim
LABEL name="Development Environment"
LABEL description="My personal development environment."
LABEL maintainer="Thomas Stachl <thomas@stachl.me>"

ARG USER="thomas" \
    PASS="password"

ENV TZ="America/Los_Angeles" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    REPO="tstachl/devenv" \
    TERM="xterm-256color" \
    EDITOR="nvim" \
    SHELL="/bin/bash"

COPY entrypoint.sh /usr/local/bin
# install required software for base image
RUN apt update && apt upgrade -y && \
    apt install -y \
      sudo curl docker git neovim openssh-client gh tzdata yadm gpg locales g++ \
    && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen \
    && \
    useradd -p $(openssl passwd -6 $PASS) -ms /bin/bash $USER && \
    usermod -aG sudo $USER && \
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | tee /etc/sudoers.d/010_$USER-nopasswd \
    chmod 0440 /etc/sudoers.d/010_$USER-nopasswd \
    && \
    chmod a+x /usr/local/bin/entrypoint.sh \
    && \
    echo "Done?"

USER $USER
SHELL ["/bin/bash", "-c"]

RUN mkdir ~/{.ssh,workspace} && touch ~/.ssh/known_hosts && \
    echo "github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==" >> ~/.ssh/known_hosts && \
    yadm clone https://github.com/tstachl/dotfiles.git --bootstrap && \
    # source ~/.config/fish/config.fish && \
    echo "configuration completed"

WORKDIR /home/thomas/workspace
CMD ["entrypoint.sh"]

