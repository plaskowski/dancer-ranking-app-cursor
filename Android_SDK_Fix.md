# Android SDK Setup Fix - GitHub Actions

## Issue Summary
The GitHub Actions release workflow is failing with `android-actions/setup-android@v3` because this action is **deprecated and no longer maintained**. The action has known compatibility issues with modern GitHub runners and Android SDK versions.

## Root Cause
- `android-actions/setup-android@v3` is outdated and unsupported
- The action fails to properly set up Android SDK on Ubuntu runners
- Newer Android SDK versions are not compatible with this action

## 🚀 Solution Options

### Option 1: Use Manual Android SDK Setup (Recommended)

Replace the `android-actions/setup-android@v3` step with manual SDK installation:

```yaml
- name: Setup Android SDK
  run: |
    # Install Android SDK
    sudo apt-get update
    sudo apt-get install -y wget unzip
    
    # Download Android Command Line Tools
    wget https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip commandlinetools-linux-9477386_latest.zip
    
    # Set up SDK directory
    mkdir -p $HOME/android-sdk/cmdline-tools
    mv cmdline-tools $HOME/android-sdk/cmdline-tools/latest
    
    # Set environment variables
    echo "ANDROID_HOME=$HOME/android-sdk" >> $GITHUB_ENV
    echo "ANDROID_SDK_ROOT=$HOME/android-sdk" >> $GITHUB_ENV
    echo "$HOME/android-sdk/cmdline-tools/latest/bin" >> $GITHUB_PATH
    echo "$HOME/android-sdk/platform-tools" >> $GITHUB_PATH
    
    # Accept licenses and install required packages
    yes | $HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager --licenses
    $HOME/android-sdk/cmdline-tools/latest/bin/sdkmanager "platform-tools" "build-tools;34.0.0" "platforms;android-34"
```

### Option 2: Use Gradle-Based Build (Flutter Recommended)

For Flutter projects, you can rely on Gradle to handle Android SDK dependencies:

```yaml
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.24.3'
    channel: 'stable'

- name: Install dependencies
  run: flutter pub get

- name: Build APK (Gradle handles Android SDK)
  run: flutter build apk --release
```

### Option 3: Use Docker Container with Pre-installed SDK

```yaml
jobs:
  merge-and-release:
    runs-on: ubuntu-latest
    container:
      image: cirrusci/flutter:3.24.3
    steps:
      # Your existing steps...
      - name: Build APK
        run: flutter build apk --release
```

## 🔧 Complete Updated Workflow

Here's your updated `.github/workflows/release.yml` with the fix:

```yaml
name: Release Build and Deploy

on:
  workflow_dispatch:
    inputs:
      release_type:
        description: 'Release type (patch, minor, major)'
        required: true
        default: 'patch'
        type: choice
        options:
          - patch
          - minor
          - major

jobs:
  merge-and-release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      actions: read
      pull-requests: write
    
    steps:
    - name: Checkout main branch
      uses: actions/checkout@v4
      with:
        ref: main
        fetch-depth: 0
        token: ${{ secrets.GITHUB_TOKEN }}
    
    - name: Configure Git
      run: |
        git config --global user.name 'github-actions[bot]'
        git config --global user.email 'github-actions[bot]@users.noreply.github.com'
    
    - name: Merge first-line branch into main
      run: |
        if git show-ref --verify --quiet refs/remotes/origin/first-line; then
          echo "Merging first-line branch..."
          git merge origin/first-line --no-ff -m "Merge first-line branch into main for release"
        else
          echo "first-line branch does not exist, skipping merge"
        fi
    
    - name: Merge second-line branch into main
      run: |
        if git show-ref --verify --quiet refs/remotes/origin/second-line; then
          echo "Merging second-line branch..."
          git merge origin/second-line --no-ff -m "Merge second-line branch into main for release"
        else
          echo "second-line branch does not exist, skipping merge"
        fi
    
    - name: Setup Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.24.3'
        channel: 'stable'
    
    - name: Install dependencies
      run: flutter pub get
    
    - name: Get current version
      id: current_version
      run: |
        current_version=$(grep '^version:' pubspec.yaml | cut -d' ' -f2)
        echo "current_version=$current_version" >> $GITHUB_OUTPUT
        echo "Current version: $current_version"
    
    - name: Bump version
      id: version_bump
      run: |
        current_version="${{ steps.current_version.outputs.current_version }}"
        version_part=$(echo $current_version | cut -d'+' -f1)
        build_number=$(echo $current_version | cut -d'+' -f2)
        
        IFS='.' read -r major minor patch <<< "$version_part"
        
        case "${{ github.event.inputs.release_type }}" in
          "major")
            major=$((major + 1))
            minor=0
            patch=0
            ;;
          "minor")
            minor=$((minor + 1))
            patch=0
            ;;
          "patch")
            patch=$((patch + 1))
            ;;
        esac
        
        build_number=$((build_number + 1))
        new_version="${major}.${minor}.${patch}+${build_number}"
        
        echo "new_version=$new_version" >> $GITHUB_OUTPUT
        echo "version_name=${major}.${minor}.${patch}" >> $GITHUB_OUTPUT
        echo "build_number=$build_number" >> $GITHUB_OUTPUT
        
        # Update pubspec.yaml
        sed -i "s/^version: .*/version: $new_version/" pubspec.yaml
        
        echo "Version bumped from $current_version to $new_version"
    
    - name: Commit version bump
      run: |
        git add pubspec.yaml
        git commit -m "bump: version to ${{ steps.version_bump.outputs.new_version }}"
    
    - name: Setup Java
      uses: actions/setup-java@v4
      with:
        distribution: 'temurin'
        java-version: '17'
    
    # REMOVED: - name: Setup Android SDK
    #           uses: android-actions/setup-android@v3
    
    - name: Build APK (Flutter handles Android SDK automatically)
      run: |
        flutter build apk --release
        
        # Rename APK with version
        mv build/app/outputs/flutter-apk/app-release.apk \
           build/app/outputs/flutter-apk/dancer-ranking-app-v${{ steps.version_bump.outputs.version_name }}.apk
    
    # ... rest of your workflow steps remain the same
```

## 🔍 Alternative: Docker-Based Solution

If you prefer a completely isolated environment:

```yaml
jobs:
  merge-and-release:
    runs-on: ubuntu-latest
    container:
      image: cirrusci/flutter:3.24.3
    permissions:
      contents: write
      actions: read
      pull-requests: write
    
    steps:
    # Your existing steps work the same way
    # Android SDK is pre-installed in the container
```

## 🚨 What Changed

1. **REMOVED**: `android-actions/setup-android@v3` step
2. **ADDED**: Flutter handles Android SDK automatically
3. **UPDATED**: Java version to 17 (more compatible)
4. **KEPT**: All your existing logic for version bumping, merging, and release creation

## 🧪 Testing the Fix

1. **Apply the changes** to your workflow file
2. **Run a test build** manually:
   ```bash
   gh workflow run release.yml
   ```
3. **Monitor the logs** for successful Android SDK setup
4. **Verify APK generation** in the artifacts

## 💡 Why This Works

- **Flutter's Android SDK management**: Flutter automatically downloads and manages the Android SDK
- **No deprecated dependencies**: Removes the problematic action
- **Simpler and more reliable**: Less moving parts = fewer failure points
- **Modern approach**: Aligns with current Flutter CI/CD best practices

## 🔗 References

- [Flutter CI/CD Documentation](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions for Flutter](https://github.com/marketplace/actions/flutter-action)
- [Android SDK Command Line Tools](https://developer.android.com/studio/command-line)

---

**Status**: Ready to implement - remove the deprecated Android setup action and let Flutter handle SDK management automatically.