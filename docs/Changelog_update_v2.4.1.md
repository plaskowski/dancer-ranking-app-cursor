# Changelog Update for v2.4.1 (2025-07-08)

### User Requests
- "flutter build apk --release does not work. Fix it please."

### Fixed
- **Android Release Build**: Removed explicit `ndkVersion` specification from `android/app/build.gradle.kts` to prevent missing-NDK errors during release builds. `flutter build apk --release` now works without requiring a specific NDK installation.

### Technical
- **Build Script**: The build script now relies on the default NDK version provided by the Flutter SDK, improving portability across developer machines and CI environments.