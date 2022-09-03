# let's set all the xdg base directories
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# let's make gnupg follow xdg conventions
export GNUPGHOME="${GNUPGHOME:-$XDG_DATA_HOME/gnupg}"
# let's make docker config follow xdg conventions
export DOCKER_CONFIG="${DOCKER_CONFIG:-$XDG_CONFIG_HOME/docker}"

# let's make bash follow xdg conventions
if [ -d "${XDG_CONFIG_HOME}/bash" ] && [ "$0" = "bash" ]; then
  . "${XDG_CONFIG_HOME}/bash/bash_profile"
  . "${XDG_CONFIG_HOME}/bash/bashrc"
  HISTFILE="${XDG_CONFIG_HOME}/bash/bash_history"
fi