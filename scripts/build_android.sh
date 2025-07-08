#!/usr/bin/env bash
set -euo pipefail

# Install prerequisites
sudo apt-get update -y
sudo apt-get install -y openjdk-17-jdk-headless wget unzip xz-utils libstdc++6 curl

# Variables
FLUTTER_VERSION="3.24.3"
FLUTTER_TAR="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_TAR}"
FLUTTER_HOME="$HOME/flutter"
ANDROID_HOME="$HOME/android-sdk"

# Download Flutter if not present
if [ ! -d "$FLUTTER_HOME" ]; then
  wget -q "$FLUTTER_URL" -O "/tmp/${FLUTTER_TAR}"
  mkdir -p "$FLUTTER_HOME"
  tar xf "/tmp/${FLUTTER_TAR}" -C "$HOME"
  mv "$HOME/flutter" "$FLUTTER_HOME" || true # tar extracts into flutter dir
fi
export PATH="$FLUTTER_HOME/bin:$PATH"

# Download Android command-line tools if not present
if [ ! -d "$ANDROID_HOME" ]; then
  mkdir -p "$ANDROID_HOME/cmdline-tools"
  CMDLINE_ZIP="commandlinetools-linux-9477386_latest.zip"
  wget -q "https://dl.google.com/android/repository/${CMDLINE_ZIP}" -O "/tmp/${CMDLINE_ZIP}"
  unzip -q "/tmp/${CMDLINE_ZIP}" -d "$ANDROID_HOME/cmdline-tools"
  mv "$ANDROID_HOME/cmdline-tools/cmdline-tools" "$ANDROID_HOME/cmdline-tools/latest"
fi

export ANDROID_HOME
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Accept licenses and install required SDK packages
yes | sdkmanager --licenses >/dev/null
sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34" "ndk;26.1.10909125" >/dev/null

# Run flutter doctor to verify
flutter doctor -v

# Fetch dependencies and build APK
flutter pub get
flutter build apk --release