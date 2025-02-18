#!/bin/bash

# ================================
# Docker Installation Script
# For: Kali Linux (Debian-based)
# ================================

# Exit immediately if a command exits with a non-zero status
set -e

# --------------------------------
# Function: Print Step
# Description: Prints a step message
# --------------------------------
print_step() {
    echo -e "\n\033[1;34m🔷 $1...\033[0m"
}

# --------------------------------
# Function: Print Success
# Description: Prints a success message
# --------------------------------
print_success() {
    echo -e "\033[1;32m✅ $1\033[0m"
}

# --------------------------------
# Function: Handle Error
# Description: Prints error message and exits
# --------------------------------
handle_error() {
    echo -e "\033[1;31m❌ Error occurred on line $1. Exiting.\033[0m\n"
    exit 1
}
trap 'handle_error $LINENO' ERR

# --------------------------------
# Step 1: Update Package List
# --------------------------------
print_step "Step 1: Updating package list"
sudo apt update
print_success "Package list updated"

# --------------------------------
# Step 2: Install Docker.io
# --------------------------------
print_step "Step 2: Installing Docker.io"
sudo apt install -y docker.io
print_success "Docker.io installed"

# --------------------------------
# Step 3: Enable & Start Docker Service
# --------------------------------
print_step "Step 3: Enabling and starting Docker service"
sudo systemctl enable docker --now
print_success "Docker service enabled and started"

# --------------------------------
# Step 4: Add Docker's GPG Key & Repository
# --------------------------------
print_step "Step 4: Adding Docker's GPG key and repository"

# Create keyring directory if not exists
sudo mkdir -p /etc/apt/keyrings

# Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Add Docker's repository to sources list
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | sudo tee /etc/apt/sources.list.d/docker.list

print_success "Docker GPG key and repository added"

# --------------------------------
# Step 5: Update Package List Again
# --------------------------------
print_step "Step 5: Updating package list after adding Docker repository"
sudo apt update
print_success "Package list updated"

# --------------------------------
# Step 6: Install Docker CE, CLI, and Containerd
# --------------------------------
print_step "Step 6: Installing Docker CE, Docker CLI, and Containerd"
sudo apt install -y docker-ce docker-ce-cli containerd.io
print_success "Docker CE, CLI, and Containerd installed"

# --------------------------------
# Step 7: Verify Docker Installation
# --------------------------------
print_step "Step 7: Verifying Docker installation"
if docker --version; then
    print_success "Docker installed successfully! 🎉"
else
    echo -e "\033[1;31m❌ Docker installation failed.\033[0m"
    exit 1
fi

# --------------------------------
# Completion Message
# --------------------------------
echo -e "\n\033[1;32m🎉 Docker setup is complete! You can now use Docker on your system.\033[0m\n"
