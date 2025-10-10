#!/bin/bash

echo "Installing Docker"

sudo apt install -y docker.io

sudo systemctl enable docker --now

# Add current user to docker group for non-sudo usage
sudo usermod -aG docker $USER
echo "You need to logout and login again to use Docker without sudo."