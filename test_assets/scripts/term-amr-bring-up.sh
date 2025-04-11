#!/bin/bash

TARGET_CONTAINER="mowbot_legacy_bring_up"

# find if the target container is existing
if [ "$(docker ps -aq -f name=$TARGET_CONTAINER)" ]; then
    # if the target container is running, stop it
    if [ "$(docker ps -q -f name=$TARGET_CONTAINER)" ]; then
        echo "Stopping existing container $TARGET_CONTAINER..."
        docker stop $TARGET_CONTAINER
    fi

    # remove the target container
    # echo "Removing existing container $TARGET_CONTAINER..."
    # docker rm $TARGET_CONTAINER
fi