#!/bin/bash
cd ${0%/*}

BUNDLE_NAME="SpotifyRCD.bundle"
BUILD_DIR="build/Release"
TWEAK_DIR="/Library/Application Support/Tweaks"

LOCAL_AGENT_PATH="/Library/LaunchAgents/com.apple.rcd.patched.plist"
SYSTEM_AGENT_PATH="/System/Library/LaunchAgents/com.apple.rcd.plist"
DYLD_PATH="$TWEAK_DIR/$BUNDLE_NAME/Contents/MacOS/SpotifyRCD"

xcodebuild clean build

echo "Administrative privileges are requred. You may be asked for a password."

echo "Copying tweak"
sudo rsync -rlptD "$BUILD_DIR/$BUNDLE_NAME" "$TWEAK_DIR"

echo "Creating new LaunchAgent"
sudo cp "$SYSTEM_AGENT_PATH" "$LOCAL_AGENT_PATH"
sudo defaults write "${LOCAL_AGENT_PATH%.*}" "EnvironmentVariables" -dict "DYLD_INSERT_LIBRARIES" "$DYLD_PATH"
sudo defaults write "${LOCAL_AGENT_PATH%.*}" "Label" "com.apple.rcd.patched"
sudo defaults write "${LOCAL_AGENT_PATH%.*}" "Disabled" -bool true
sudo chmod 0644 "$LOCAL_AGENT_PATH"

echo "Unloading system LaunchAgent"
launchctl unload -w "$SYSTEM_AGENT_PATH"

echo "Loading modified LaunchAgent"
launchctl load -w "$LOCAL_AGENT_PATH"
