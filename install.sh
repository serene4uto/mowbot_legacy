#!/bin/bash

# get home directory
HOME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# run udev rules
bash "$SCRIPT_DIR/udev/create_udev_rules.sh"

# ensure ssh-agent is running
eval "$(ssh-agent -s)"
# add ssh key to agent
ssh-add "$HOME_DIR/.ssh/id_rsa"

# first, build or pull the docker image
bash "$SCRIPT_DIR/docker/build.sh"

# copy common data directory to $HOME_DIR
cp -r "$SCRIPT_DIR/mowbot_legacy_data" "$HOME_DIR/"


# remove src
# rm -rf "$SCRIPT_DIR/src"


