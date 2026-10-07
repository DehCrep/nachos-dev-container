#!/usr/bin/env bash

# This scripts must create a zip archive named
# "environment.zip" in order to comply with the
# release pipeline's expectations.

set -euo pipefail

# Remove previous environment.zip
rm -f environment.zip

# Creates a temp directory and deletes it when the script ends 
STAGE_DIR=$(mktemp -d)
trap 'rm -rf "$STAGE_DIR"' EXIT

# Create destination subdirectories first
mkdir -p "$STAGE_DIR/.devcontainer" "$STAGE_DIR/.vscode"

# Copy the relevent files in the temp directory
DEVCONTAINER_JSON="$STAGE_DIR/.devcontainer/devcontainer.json"

cp .devcontainer/devcontainer.json "$DEVCONTAINER_JSON"
cp .vscode/launch.json "$STAGE_DIR/.vscode/launch.json"
cp .gitignore.nachos "$STAGE_DIR/.gitignore"

# modify the .devcontainer to prevent build
sed -i '/"build"[[:space:]]*:[[:space:]]*{/,/}/ s/^\([[:space:]]*\)/\1\/\//' "$DEVCONTAINER_JSON"

# Create the release archive in the workspace directory
(cd "$STAGE_DIR" && zip -r -q "$OLDPWD/environment.zip" .devcontainer .vscode .gitignore)

echo "Done"