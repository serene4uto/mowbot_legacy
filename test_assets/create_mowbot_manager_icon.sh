#!/bin/bash

SETUP_DIR="/home/$USER/mowbot_legacy/test_assets"
SCRIPTS_DIR="$SETUP_DIR/py_scripts"
RESOURCES_DIR="$SETUP_DIR/resources"

# Loop through each Python script in the directory
for file in "$SCRIPTS_DIR"/*.py; do

    # Get the name of the script file without the extension
    name=$(basename "${file%.py}")

    # Set the name of the desktop launcher file
    desktop_file="$name.desktop"

    # Command to run the Python script in a terminal and keep it open
    command="bash -c 'python3 \"$file\"; exec bash'"

    # Create the desktop launcher file
    echo "[Desktop Entry]" > "$desktop_file"
    echo "Type=Application" >> "$desktop_file"
    echo "Name=$name" >> "$desktop_file"
    echo "Icon=$RESOURCES_DIR/mowbot_app_icon.jpg" >> "$desktop_file"
    echo "Exec=$command" >> "$desktop_file"
    echo "Terminal=false" >> "$desktop_file"

    # Make the desktop launcher file executable
    chmod +x "$desktop_file"

    # Move the desktop launcher file to the actual desktop directory
    mv "$desktop_file" "$HOME/Desktop/"

done

sleep 2

# Trust all .desktop files on Desktop
cd "$HOME/Desktop" || exit 1

for file in "$HOME/Desktop"/*.desktop; do
    gio set "$file" metadata::trusted true
    chmod a+x "$file"
done
