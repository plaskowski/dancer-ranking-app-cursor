#!/bin/bash

# Release script for Dancer Ranking App
# This script bumps version, builds APK, and uploads to GitHub releases

set -e  # Exit on any error

# Configuration
APP_NAME="Dancer Ranking App"
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
CHANGELOG_FILE="Changelog.md"

# Function to print output
print_status() {
    echo "[INFO] $1"
}

print_success() {
    echo "[SUCCESS] $1"
}

print_warning() {
    echo "[WARNING] $1"
}

print_error() {
    echo "[ERROR] $1"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
check_prerequisites() {
    print_status "Checking prerequisites..."
    
    if ! command_exists flutter; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    if ! command_exists gh; then
        print_error "GitHub CLI (gh) is not installed. Please install it first:"
        print_error "  macOS: brew install gh"
        print_error "  Linux: sudo apt install gh"
        print_error "  Windows: winget install GitHub.cli"
        exit 1
    fi
    
    if ! gh auth status >/dev/null 2>&1; then
        print_error "GitHub CLI is not authenticated. Please run: gh auth login"
        exit 1
    fi
    
    print_success "Prerequisites check passed"
}

# Function to get current version from changelog
get_current_version() {
    local version_line=$(grep -m 1 '^## \[v[0-9]\+\.[0-9]\+\.[0-9]\+]' "$CHANGELOG_FILE")
    if [[ -z "$version_line" ]]; then
        print_error "Could not find version in $CHANGELOG_FILE"
        exit 1
    fi
    echo "$version_line" | sed 's/^## \[v\(.*\)\].*/\1/'
}

# Function to bump version
bump_version() {
    local current_version=$1
    local bump_type=${2:-patch}
    
    print_status "Current version: $current_version"
    print_status "Bump type: $bump_type"
    
    # Parse version components
    IFS='.' read -ra VERSION_PARTS <<< "$current_version"
    local major=${VERSION_PARTS[0]}
    local minor=${VERSION_PARTS[1]}
    local patch=${VERSION_PARTS[2]}
    
    # Bump version based on type
    case $bump_type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_error "Invalid bump type: $bump_type. Use major, minor, or patch"
            exit 1
            ;;
    esac
    
    local new_version="$major.$minor.$patch"
    echo "$new_version"
}

# Function to update changelog
update_changelog() {
    local new_version=$1
    local current_date=$(date +%Y-%m-%d)
    
    print_status "Updating changelog..."
    
    # Create new version section
    local new_section="## [v$new_version] - $current_date

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

"
    
    # Create a temporary file with the new section
    local temp_file=$(mktemp)
    echo "$new_section" > "$temp_file"
    
    # Insert new section after the first version entry
    awk '/^## \[v[0-9]+\.[0-9]+\.[0-9]+]/ { print; system("cat '"$temp_file"'"); next } { print }' "$CHANGELOG_FILE" > "$CHANGELOG_FILE.tmp"
    mv "$CHANGELOG_FILE.tmp" "$CHANGELOG_FILE"
    
    # Clean up temp file
    rm -f "$temp_file"
    
    print_success "Changelog updated"
}

# Function to build APK
build_apk() {
    print_status "Building APK..."
    
    # Clean previous build
    print_status "Cleaning previous build..."
    flutter clean
    
    # Get dependencies
    print_status "Getting dependencies..."
    flutter pub get
    
    # Build APK
    print_status "Building release APK..."
    flutter build apk --release
    
    if [[ ! -f "$APK_PATH" ]]; then
        print_error "APK build failed - file not found at $APK_PATH"
        exit 1
    fi
    
    print_success "APK built successfully: $APK_PATH"
}

# Function to create GitHub release
create_github_release() {
    local version=$1
    local release_notes=$2
    
    print_status "Creating GitHub release for v$version..."
    
    # Check if tag already exists (use simpler check)
    if git tag | grep -Fxq "v$version"; then
        print_error "Tag v$version already exists. Please bump version or delete existing tag."
        exit 1
    fi
    
    # Create release with APK
    if gh release create "v$version" \
        "$APK_PATH" \
        --title "v$version" \
        --notes "$release_notes" \
        --draft=false; then
        print_success "GitHub release created successfully"
        print_status "Release URL: https://github.com/$(gh repo view --json nameWithOwner -q .nameWithOwner)/releases/tag/v$version"
    else
        print_error "Failed to create GitHub release"
        print_error "Please check:"
        print_error "1. You have write access to the repository"
        print_error "2. The repository is correctly configured"
        print_error "3. GitHub CLI is properly authenticated"
        exit 1
    fi
}

# Function to commit and push changes
commit_and_push() {
    local version=$1
    
    print_status "Committing and pushing changes..."
    
    # Add all changes
    git add .
    
    # Commit
    git commit -m "chore: bump version to v$version and prepare release"
    
    # Push
    git push origin HEAD
    
    print_success "Changes committed and pushed"
}

# Function to update pubspec.yaml version
update_pubspec_version() {
    local new_version=$1
    
    print_status "Updating pubspec.yaml version..."
    
    # Calculate version code (remove dots and convert to integer)
    local version_code=$(echo $new_version | tr -d '.')
    
    # Update the version line in pubspec.yaml
    sed -i.bak "s/^version: .*$/version: $new_version+$version_code/" pubspec.yaml
    
    # Clean up backup file
    rm -f pubspec.yaml.bak
    
    print_success "pubspec.yaml version updated to $new_version+$version_code"
    print_status "Android version code: $version_code"
}

# Function to validate Android version update
validate_android_version() {
    local new_version=$1
    
    print_status "Validating Android version update..."
    
    # Check if pubspec.yaml was updated correctly
    local current_pubspec_version=$(grep "^version:" pubspec.yaml | sed 's/version: //')
    local expected_version_code=$(echo $new_version | tr -d '.')
    local expected_pubspec_version="$new_version+$expected_version_code"
    
    if [[ "$current_pubspec_version" != "$expected_pubspec_version" ]]; then
        print_error "pubspec.yaml version mismatch. Expected: $expected_pubspec_version, Got: $current_pubspec_version"
        exit 1
    fi
    
    print_success "Android version validation passed"
    print_status "Version name: $new_version"
    print_status "Version code: $expected_version_code"
}

# Main function
main() {
    local bump_type=${1:-patch}
    
    print_status "Starting release process for $APP_NAME"
    print_status "Bump type: $bump_type"
    
    # Check prerequisites
    check_prerequisites
    
    # Get current version and bump version - no status messages during assignment
    local current_version
    current_version=$(get_current_version)
    
    local new_version
    new_version=$(bump_version "$current_version" "$bump_type" | tail -n 1)
    
    # Now print status messages after assignments are complete
    print_status "Current version: $current_version"
    print_status "New version: $new_version"
    
    # Update changelog
    update_changelog "$new_version"
    
    # Update pubspec.yaml version
    update_pubspec_version "$new_version"
    
    # Validate Android version update
    validate_android_version "$new_version"
    
    # Build APK
    build_apk
    
    # Get APK size
    local apk_size=$(du -h "$APK_PATH" | cut -f1)
    print_status "APK size: $apk_size"
    
    # Create release notes
    local version_code=$(echo $new_version | tr -d '.')
    release_notes="## What's New in v$new_version

This release includes the latest features and improvements for the Dancer Ranking App.

### Download
- APK Size: $apk_size
- Version Code: $version_code
- Compatible with Android 5.0+ (API level 21+)

### Installation
1. Download the APK file
2. Enable \"Install from unknown sources\" in your Android settings
3. Install the APK file

### Support
For issues or feature requests, please visit the GitHub repository.

---
*Built with Flutter and ❤️ for the dance community*"
    
    # Create GitHub release
    create_github_release "$new_version" "$release_notes"
    
    # Commit and push changes
    commit_and_push "$new_version"
    
    print_success "Release process completed successfully!"
    print_status "Version bumped to: v$new_version"
    print_status "Android version code: $(echo $new_version | tr -d '.')"
    print_status "APK uploaded to GitHub releases"
    print_status "Changes committed and pushed to main branch"
}

# Show usage if no arguments provided
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 [bump_type]"
    echo ""
    echo "Bump types:"
    echo "  patch  - Increment patch version (default)"
    echo "  minor  - Increment minor version"
    echo "  major  - Increment major version"
    echo ""
    echo "Examples:"
    echo "  $0           # Bump patch version"
    echo "  $0 minor     # Bump minor version"
    echo "  $0 major     # Bump major version"
    exit 0
fi

# Run main function
main "$@" 