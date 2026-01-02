#!/bin/bash

set -eu

USER_UID=${DEFAULT_UID:-1000}
USER_GID=${DEFAULT_GID:-1000}
USER_NAME=${DEFAULT_USERNAME:-gemini}
USER_HOME=${DEFAULT_HOME_DIR:-/home/$USER_NAME}

echo "Creating unprivileged user matching system user..."
echo "  Name:     $USER_NAME"
echo "  UID:      $USER_UID"
echo "  GID:      $USER_GID"
echo "  Home dir: $USER_HOME"

# create group if it doesn't exist
getent group $USER_GID 2>&1 > /dev/null || addgroup --gid $USER_GID $USER_NAME

# create user if it doesn't exist
getent passwd $USER_UID 2>&1 > /dev/null || adduser --disabled-password --no-create-home --gecos "" --home "$USER_HOME" --uid $USER_UID --gid $USER_GID $USER_NAME

chown $USER_NAME:$USER_NAME $USER_HOME
gosu $USER_NAME:$USER_NAME bash -c "mkdir -p $USER_HOME/.gemini $USER_HOME/.local/bin"
export PATH="$USER_HOME/.local/bin:$USER_HOME/.local/sbin:$PATH"

if [[ "$ENABLE_SUDO" -eq 1 ]]; then
    echo 'gemini ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/gemini
fi

gosu $USER_NAME:$USER_NAME "$@"
