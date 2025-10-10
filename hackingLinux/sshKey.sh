#!/bin/bash

KEY_PATH="$HOME/.ssh/deploy_key"

echo "=== Generating deploy key for repository ==="
ssh-keygen -t ed25519 -f "$KEY_PATH" -N ""

eval "$(ssh-agent -s)"
ssh-add "$KEY_PATH"

echo
echo "=== Your public SSH key ==="
cat "${KEY_PATH}.pub"

read -p "Press ENTER after you have added the key to GitHub..."

echo "Verifying GitHub SSH connection..."
ssh -T git@github.com
