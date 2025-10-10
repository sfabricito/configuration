#!/usr/bin/env bash
set -euo pipefail


# install_angr.sh
# Creates a Python virtualenv for angr under $HOME/Tools/Angr/angr,
# installs angr and ipython, and places a small wrapper script in ~/.local/bin/angr
# so you can run `angr` from any shell (no sudo required for the wrapper).


VENV_DIR="$HOME/Tools/Angr/angr"
LOCAL_BIN="$HOME/.local/bin"
WRAPPER="$LOCAL_BIN/angr"


echo "This script will:"
echo " - install OS packages (python3-venv, pip, build tools) using sudo"
echo " - create virtualenv: $VENV_DIR"
echo " - install angr and ipython into the venv"
echo " - create wrapper: $WRAPPER (runs IPython inside the venv)"


echo
read -p "Proceed? [y/N]: " -r PROCEED
case "$PROCEED" in
[yY][eE][sS]|[yY]) ;;
*) echo "Aborted."; exit 1 ;;
esac


# Update and install dependencies (may ask for your sudo password)
sudo apt update
sudo apt install -y python3-venv python3-pip build-essential libssl-dev libffi-dev zlib1g-dev


# Prepare directories
mkdir -p "$(dirname "$VENV_DIR")"


# Create virtualenv (idempotent)
if [ -d "$VENV_DIR" ]; then
echo "Virtualenv already exists at $VENV_DIR -- skipping creation"
else
python3 -m venv "$VENV_DIR"
echo "Created venv at $VENV_DIR"
fi


# Upgrade pip and install packages inside venv
"$VENV_DIR/bin/pip" install --upgrade pip setuptools wheel
"$VENV_DIR/bin/pip" install angr ipython


# Create wrapper script in ~/.local/bin
mkdir -p "$LOCAL_BIN"
cat > "$WRAPPER" <<'EOF'
#!/usr/bin/env bash
# wrapper to run IPython inside the angr virtualenv
VENV_DIR="$HOME/Tools/Angr/angr"
exec "$VENV_DIR/bin/python" -m IPython "$@"
EOF


chmod +x "$WRAPPER"


# Ensure ~/.local/bin is in ~/.bashrc PATH (only add if command not found after wrapper)
if ! command -v angr >/dev/null 2>&1; then
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" 2>/dev/null; then
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
echo 'Added ~/.local/bin to PATH in ~/.bashrc. Run `source ~/.bashrc` or open a new shell.'
fi
fi


cat <<EOF