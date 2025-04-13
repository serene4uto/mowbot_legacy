#!/bin/bash

# Get home directory relative to the script location
HOME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export DISPLAY=:0
xhost +local:docker

docker run --rm -it \
    --name test_wp_set \
    --network host \
    -e DISPLAY=:0.0 \
    -w /mowbot_legacy \
    -v "$HOME_DIR/mowbot_legacy_data:/mowbot_legacy_data" \
    -v "/dev:/dev" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix" \
    ghcr.io/serene4uto/mowbot-legacy-base /bin/bash -c "\
        cd /mowbot_legacy \
        && . ./install/setup.bash \
        && ros2 launch mowbot_legacy_launch test_wp_set.launch.py \
            mapviz:=true \
            rl:=false \
    "