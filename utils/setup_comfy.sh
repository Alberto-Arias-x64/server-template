#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print messages
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    print_error "Please run this script as root (sudo)"
    exit 1
fi

# Update system
print_message "Updating system..."
apt update && apt upgrade -y

# Clone ComfyUI
cd /home/flux
print_message "Cloning ComfyUI..."
git clone https://github.com/comfyanonymous/ComfyUI.git


# Activate virtual environment
cd ComfyUI
pyenv shell 3.12
sudo apt install python3-venv
print_message "Creating virtual environment..."
python3 -m venv .venv
print_message "Activating virtual environment..."
source .venv/bin/activate

# Install dependencies
print_message "Installing dependencies..."
pip3 install -r requirements.txt
pip3 install --pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu128
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager

deactivate

print_message "Installation complete!"