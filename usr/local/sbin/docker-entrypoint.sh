#!/bin/bash

set -eu

UID=${DEFAULT_UID:-1000}
GID=${DEFAULT_GID:-1000}
USER=${DEFAULT_USERNAME:-gemini}
HOME=${DEFAULT_HOME_DIR:-/home/$USER}

echo "Creating unprivileged user matching system user..."
echo "  Name:     $USER"
echo "  UID:      $UID"
echo "  GID:      $GID"
echo "  Home dir: $HOME"

# create group if it doesn't exist
getent group $GID 2>&1 > /dev/null || addgroup --gid $GID $USER

# create user if it doesn't exist
getent passwd $UID 2>&1 > /dev/null || adduser --disabled-password --no-create-home --gecos "" --home "$HOME" --uid $UID --gid $GID $USER

chown $USER:$USER $HOME
gosu $USER:$USER bash -c "mkdir -p $HOME/.gemini $HOME/.local/bin"
export PATH="$HOME/.local/bin:$HOME/.local/sbin:$PATH"

if [[ "$ENABLE_SUDO" -eq 1 ]]; then
    echo 'gemini ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/gemini
fi

gosu $USER:$USER "$@"
