#!/bin/bash

# ================================
# Docker Installation Script
# For: Kali Linux (Debian-based)
# ================================

# Exit immediately if a command fails
set -e

# Function: Print Success
print_success() {
    echo -e "\033[1;32m✅ $1\033[0m"
}

# Function: Print Error and Exit
print_error() {
    echo -e "\033[1;31m❌ Error occurred on line $1. Exiting.\033[0m\n"
    exit 1
}
trap 'print_error $LINENO' ERR

# Function: Check if Command Exists
check_command() {
    if ! command -v "$1" &> /dev/null; then
        sudo apt install -y "$1"
    fi
}

# Prerequisite Check
check_command curl
check_command gpg
check_command pass
print_success "All prerequisites are installed"

# Update Package List
sudo apt update -y
print_success "Package list updated"

# Install Docker.io
sudo apt install -y docker.io
print_success "Docker.io installed"

# Enable & Start Docker Service
sudo systemctl enable docker --now
print_success "Docker service enabled and started"

# Add Docker's GPG Key & Repository
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
print_success "Docker GPG key and repository added"

# Update Package List Again
sudo apt update -y
print_success "Package list updated"

# Install Docker CE, CLI, and Containerd
sudo apt install -y docker-ce docker-ce-cli containerd.io
print_success "Docker CE, CLI, and Containerd installed"

# Verify Docker Installation
if docker --version; then
    print_success "Docker installed successfully! 🎉"
else
    echo -e "\033[1;31m❌ Docker installation failed.\033[0m"
    exit 1
fi

# Prompt for Docker Group Addition
read -rp $'\033[1;36mDo you want to add the current user to the Docker group? (y/n): \033[0m' response
case "$response" in
    [yY][eE][sS]|[yY]) 
        sudo usermod -aG docker "$USER"
        print_success "User added to Docker group. Reboot or logout required for changes to take effect."
        ;;
    [nN][oO]|[nN]) 
        echo -e "\033[1;33m⚠️  Skipping Docker group addition. You will need to use 'sudo' for Docker commands.\033[0m"
        ;;
    *) 
        echo -e "\033[1;31mInvalid input. Skipping Docker group addition.\033[0m"
        ;;
esac

# Install Docker Desktop
curl -fsSL -o docker-desktop.deb "https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb?utm_source=docker&utm_medium=webreferral&utm_campaign=docs-driven-download-linux-amd64"
sudo apt install -y ./docker-desktop.deb
rm docker-desktop.deb
print_success "Docker Desktop installed successfully"

# Initialize pass for Docker Desktop authentication
print_success "Initializing pass for Docker Desktop authentication"
gpg --generate-key

echo -e "\033[1;36mEnter the generated GPG key ID: \033[0m"
read GPG_KEY_ID
pass init "$GPG_KEY_ID"
print_success "Pass initialized with GPG key: $GPG_KEY_ID"

# Completion Message
echo -e "\n\033[1;32m🎉 Docker setup is complete! You can now use Docker and Docker Desktop on your system.\033[0m\n"
