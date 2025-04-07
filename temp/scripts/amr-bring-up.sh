export DISPLAY=:0
xhost +local:docker
docker start mowbot_legacy
docker exec -it -e DISPLAY=:0.0 -w /workspaces/mowbot_legacy mowbot_legacy /bin/bash -c "\
        cd /workspaces/mowbot_legacy \
        && . ./install/setup.bash \
        && ros2 launch mowbot_legacy_launch bringup.launch.py uros:=true foxglove:=true \
            imu:=true madgwick:=true \
            ntrip:=true gpsl:=true gpsr:=true dgps_compass:=true \
            laser:=true \
    "