#!/bin/bash

# Define Docker container name
CONTAINER_NAME="mowbot_legacy_dev"

# Get the PID of the ROS2 launch command inside the Docker container
ROS2_LAUNCH_PID=$(docker exec "$CONTAINER_NAME" pgrep -f "ros2 run py_mowbot_utils system_monitor_2")

if [ -z "$ROS2_LAUNCH_PID" ]; then
    echo "No ROS2 launch process found in container $CONTAINER_NAME."
    exit 1
fi

echo "Found ROS2 launch process with PID: $ROS2_LAUNCH_PID in container $CONTAINER_NAME."

# Find and kill the entire process tree of the ROS2 launch command
docker exec "$CONTAINER_NAME" bash -c "pstree -p $ROS2_LAUNCH_PID | grep -oP '\(\d+\)' | grep -oP '\d+' | xargs kill -9"

if [ $? -eq 0 ]; then
    echo "Successfully killed ROS2 launch process and its children."
else
    echo "Failed to kill ROS2 launch process."
fi