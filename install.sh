#!/bin/bash

# get home directory
HOME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ensure ssh-agent is running
eval "$(ssh-agent -s)"
# add ssh key to agent
ssh-add "$HOME_DIR/.ssh/id_rsa"

# first, build or pull the docker image
bash "$SCRIPT_DIR/docker/build.sh"

# create common data directory at $HOME_DIR
mkdir -p "$HOME_DIR/mowbot_legacy_data"

# remove src
# rm -rf "$SCRIPT_DIR/src"


