export DISPLAY=:0
xhost +local:docker
docker start mowbot_legacy_dev
docker exec -it -e DISPLAY=:0.0 -w /workspaces/mowbot_legacy mowbot_legacy_dev /bin/bash -c "\
        cd /workspaces/mowbot_legacy \
        && . ./install/setup.bash \
        && ros2 launch mowbot_legacy_launch test_wp_bringup.launch.py \
            uros:=true foxglove:=true \
            imu:=true madgwick:=true \
            ntrip:=true gps:=true \
            laser:=true \
            rl:=false \
    "