SETUP_DIR="/home/$USER/mowbot_legacy/temp"
SCRIPTS_DIR="/home/$USER/mowbot_legacy/temp/scripts/misc"
RESOURCES_DIR="/home/$USER/mowbot_legacy/temp/resources"

# Loop through each Bash script in the directory
for file in "$SCRIPTS_DIR"/*.sh; do

    # Get the name of the script file without the extension
    name=$(basename "${file%.sh}")

    # Set the name of the desktop launcher file
    desktop_file="$name.desktop"

    # Set the command to execute the script in a new terminal window
    # command="gnome-terminal -- bash -c 'bash $file; exec bash'"
    command="gnome-terminal -- bash -c 'bash $file; exec bash'"

    # Create the desktop launcher file
    echo "[Desktop Entry]" > "$desktop_file"
    echo "Type=Application" >> "$desktop_file"
    echo "Name=$name" >> "$desktop_file"
    echo "Icon=$RESOURCES_DIR/mowbot_app_icon.jpg" >> "$desktop_file"
    echo "Exec=$command" >> "$desktop_file"
    echo "Terminal=false" >> "$desktop_file"

    # Make the desktop launcher file executable
    chmod +x "$desktop_file"

    # Move the desktop launcher file to the desktop directory
    mv "$desktop_file" ~/Desktop/

done

sleep 2

# Make desktop app launchable
cd /home/$USER/Desktop

APP_DIR="/home/$USER/Desktop"

# Loop through each app in the directory
for file in "$APP_DIR"/*.desktop; do
    # Get the name of the script file without the extension
    name=$(basename "${file%.desktop}")

    desktop_file="$name.desktop"

    gio set "$desktop_file" metadata::trusted true

    chmod a+x "$desktop_file"
done
