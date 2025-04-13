export DISPLAY=:0
xhost +local:docker

docker exec -it -e DISPLAY=:0.0 -w /workspaces/mowbot_legacy mowbot_legacy_dev /bin/bash -c "\
        cd /workspaces/mowbot_legacy \
        && . ./install/setup.bash \
        && ros2 launch mowbot_legacy_launch test_wp_set.launch.py \
            mapviz:=true \
            rl:=false \
    "