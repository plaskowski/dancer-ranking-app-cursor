# Changelog

All notable changes to the Dancer Ranking App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.6.0] - 2025-01-27

### Added
- **Integration Testing Framework**: Comprehensive integration test suite for end-to-end app functionality
  - Basic app navigation and UI tests (`app_test.dart`)
  - Dancer management workflow tests (`dancer_management_test.dart`)
  - Import functionality tests (`import_functionality_test.dart`)
  - Test runner script for easy execution (`run_integration_tests.sh`)
  - Comprehensive documentation (`README.md`)

### Technical
- Added `integration_test` dependency to `pubspec.yaml`
- Created `integration_test/` directory with organized test structure
- Implemented test coverage for core user workflows:
  - App launch and navigation
  - Event creation and management
  - Dancer addition and ranking
  - Settings navigation
  - Import functionality accessibility

### User Requests
- "Let's introduce integration tests"

## [v2.5.0] - 2025-01-27

### Fixed
- Robust default rank selection for import functionality
- Reordered activity filter options for better UX

### Technical
- Improved rank selection logic to handle user-customized rank names
- Enhanced filter UI organization and accessibility 