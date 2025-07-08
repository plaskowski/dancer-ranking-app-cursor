#!/usr/bin/env bash
# ---------------------------------------------
# Basic release helper for Dancer Ranking App
# ---------------------------------------------
# Bumps the pubspec version, updates CHANGELOG, commits, tags & pushes.
#
# Usage: ./scripts/release.sh [patch|minor|major] [--dry-run]
# ---------------------------------------------
set -euo pipefail

SEMVER_PART=${1:-patch}
DRY_RUN=${2:-}
if [[ "$SEMVER_PART" != "patch" && "$SEMVER_PART" != "minor" && "$SEMVER_PART" != "major" ]]; then
  echo "Usage: $0 [patch|minor|major] [--dry-run]" >&2
  exit 1
fi

# Extract current version & build
version_line=$(grep '^version:' pubspec.yaml)
current_full=${version_line#version: }
current_version=${current_full%%+*}
current_build=${version_line##*+}
IFS='.' read -r major minor patch <<<"$current_version"

case "$SEMVER_PART" in
  patch) patch=$((patch+1)); ;;
  minor) minor=$((minor+1)); patch=0 ;;
  major) major=$((major+1)); minor=0; patch=0 ;;
esac
new_build=$((current_build+1))
new_version="$major.$minor.$patch+$new_build"

echo "Releasing $new_version (bump $SEMVER_PART)"

if [[ "$DRY_RUN" == "--dry-run" ]]; then
  echo "DRY-RUN mode – no files will be modified."
  exit 0
fi

# Update pubspec.yaml
sed -i.bak -E "s/^version: .*/version: $new_version/" pubspec.yaml && rm pubspec.yaml.bak

# Prepend CHANGELOG stub
release_date=$(date +%Y-%m-%d)
changelog_header="\n## [v$new_version] - $release_date\n### Added\n- _TBD_\n### Changed\n- _TBD_\n### Fixed\n- _TBD_\n### Technical\n- Automated version bump\n"
sed -i.bak "3 i $changelog_header" Changelog.md && rm Changelog.md.bak

# Commit, tag, push
git add pubspec.yaml Changelog.md
git commit -m "chore: bump version to $new_version"
git tag "v$new_version"
git push && git push --tags

echo "Release $new_version complete! GitHub Actions should build & publish." 