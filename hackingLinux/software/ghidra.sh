#!/bin/sh
set -e

TOOLS_DIR="$HOME/Tools"
GHIDRA_PARENT_DIR="$TOOLS_DIR/Ghidra"
ZIP_NAME="ghidra_11.4.2_PUBLIC_20250826.zip"
URL="https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_11.4.2_build/${ZIP_NAME}"
BASHRC="$HOME/.bashrc"

echo "Installing Ghidra into: $GHIDRA_PARENT_DIR"

mkdir -p "$TOOLS_DIR"

if [ -d "$GHIDRA_PARENT_DIR" ]; then
  echo "Found existing $GHIDRA_PARENT_DIR — removing it..."
  rm -rf "$GHIDRA_PARENT_DIR"
fi

mkdir -p "$GHIDRA_PARENT_DIR"
cd "$GHIDRA_PARENT_DIR"

echo "Downloading $ZIP_NAME..."
if command -v wget >/dev/null 2>&1; then
  wget -O "$ZIP_NAME" "$URL"
elif command -v curl >/dev/null 2>&1; then
  curl -L -o "$ZIP_NAME" "$URL"
else
  echo "Error: neither wget nor curl is installed." >&2
  exit 1
fi

echo "Unzipping..."
unzip -q "$ZIP_NAME"

EXTRACTED_DIR=$(ls -1 | grep '^ghidra_' | head -n 1 || true)
if [ -z "$EXTRACTED_DIR" ]; then
  echo "Error: could not find extracted Ghidra directory." >&2
  ls -la
  exit 1
fi

if [ -f "$EXTRACTED_DIR/ghidraRun" ]; then
  chmod +x "$EXTRACTED_DIR/ghidraRun"
  echo "Made $EXTRACTED_DIR/ghidraRun executable."
else
  echo "Warning: $EXTRACTED_DIR/ghidraRun not found. Check extraction." >&2
fi

ALIAS_LINE="alias ghidra=\"$GHIDRA_PARENT_DIR/$EXTRACTED_DIR/ghidraRun\""
if ! grep -Fqx "$ALIAS_LINE" "$BASHRC" 2>/dev/null; then
  echo "$ALIAS_LINE" >> "$BASHRC"
  echo "Added alias to $BASHRC"
else
  echo "Alias already present in $BASHRC"
fi

. "$BASHRC" 2>/dev/null || true

echo "Installation complete. Run 'ghidra' to start Ghidra (you may need to open a new terminal)."
