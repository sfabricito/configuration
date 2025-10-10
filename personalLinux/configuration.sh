#!/bin/bash

sudo apt update
sudo apt full-upgrade -y

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required. Rebooting now..."
    sudo reboot -f
fi

# Software installations
./software/docker.sh
./software/virtualBox.sh

# Github ssh key generation
./sshKey.sh