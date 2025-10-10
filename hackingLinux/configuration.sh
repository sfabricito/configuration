#!/bin/bash

sudo apt update
sudo apt full-upgrade -y

if [ -f /var/run/reboot-required ]; then
    echo "A reboot is required. Rebooting now..."
    sudo reboot -f
fi

# Software installations
./software/javaSDK.sh

# Github ssh key generation
./sshKey.sh