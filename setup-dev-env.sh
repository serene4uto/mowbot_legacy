  #!/usr/bin/env bash
# Set up development environment for Mowbot Legacy.
# Usage: setup-dev-env.sh ...
# Note: -y option is only for CI.

set -e

# Function to print help message
print_help() {
    echo "Usage: setup-dev-env.sh [OPTIONS]"
    echo "Options:"
    echo "  --help          Display this help message"
    echo "  -h              Display this help message"
    echo "  -y              Use non-interactive mode"
    echo "  -v              Enable debug outputs"
    echo "  --data-dir      Set data directory (default: $HOME/mowbot_legacy_data)"
    echo ""
}

SCRIPT_DIR=$(readlink -f "$(dirname "$0")") # Absolute path of this script

# Parse arguments
args=()
option_data_dir="$HOME/mowbot_legacy_data"

while [ "$1" != "" ]; do
    case "$1" in
    --help | -h)
        print_help
        exit 1
        ;;
    -y)
        # Use non-interactive mode.
        option_yes=true
        ;;
    -v)
        # Enable debug outputs.
        option_verbose=true
        ;;
    --data-dir)
        # Set data directory
        option_data_dir="$2"
        shift
        ;;
    --module)
        option_module="$2"
        shift
        ;;
    *)
        args+=("$1")
        ;;
    esac
    shift
done

# Load env
source "$SCRIPT_DIR/amd64.env"
if [ "$(uname -m)" = "aarch64" ]; then
    source "$SCRIPT_DIR/arm64.env"
fi

# Install sudo
if ! (command -v sudo >/dev/null 2>&1); then
    apt-get -y update
    apt-get -y install sudo
fi

# Install git
if ! (command -v git >/dev/null 2>&1); then
    sudo apt-get -y update
    sudo apt-get -y install git
fi

# Install pip
if ! (python3 -m pip --version >/dev/null 2>&1); then
    sudo apt-get -y update
    sudo apt-get -y install python3-pip python3-venv
fi



