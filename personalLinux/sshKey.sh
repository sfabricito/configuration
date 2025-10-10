#!/bin/bash

KEY_PATH="$HOME/.ssh/id_ed25519"

ssh-keygen -t ed25519 -C "sfabricito@gmail.com" -f "$KEY_PATH" -N ""
eval "$(ssh-agent -s)"

ssh-add "$KEY_PATH"

echo "=== Your public SSH key ==="
cat "${KEY_PATH}.pub"
echo "=========================="
echo ""

read -p "Press ENTER after you have added the key to GitHub..."

echo "Verifying GitHub SSH connection..."
ssh -T git@github.com
