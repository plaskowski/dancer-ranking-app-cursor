# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.4.0] - 2025-01-17
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "amend the release script to also update the android app version" - Request to update release script for Android version management
- "Have you implemented this? how android version in settings" - Request to display Android version in app settings

### Added
- **Android Version Display**: Added version information to Settings screen
  - **App Information Section**: Shows current app version and build number
  - **Dynamic Loading**: Uses package_info_plus to fetch runtime version data
  - **User-Friendly Display**: Shows version as "1.4.0 (140)" format
  - **Automatic Sync**: Version always matches pubspec.yaml and release script
- **Enhanced Release Script**: Improved Android version management in release process
  - **Version Code Calculation**: Automatically converts semantic version to Android version code
  - **Validation Step**: Confirms Android version was properly updated before building
  - **Enhanced Logging**: Shows both version name and version code in output
  - **Release Notes Integration**: Includes version code in GitHub release notes

### Changed
- **Release Script**: Updated to properly handle Android version management
  - **pubspec.yaml Updates**: Now updates both version name and version code
  - **Validation Process**: Added Android version validation before building
  - **Better Error Handling**: Ensures version consistency across all files
  - **Enhanced Success Messages**: Shows version information in final output

### Technical
- Added `package_info_plus` dependency for app version information
- Updated `GeneralSettingsTab` to display Android version and build number
- Enhanced release script with Android version validation and logging
- Improved version code calculation and pubspec.yaml updates
- Added proper error handling for version management

## [v1.3.8] - 2025-01-17
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I don't like the activity categories, let's redefine them" - Request to redefine activity level filtering categories
- "Mixed ones: Regular (3+ dances in last 2 months), Occasional (1+ dance in last 3 months), All" - Request for new activity level definitions

### Changed
- **Activity Level Categories**: Redefined activity level filtering to use more intuitive categories
  - **Regular**: 3+ dances in last 2 months (replaces "Very Active" and "Core Community")
  - **Occasional**: 1+ dance in last 3 months (replaces "Active" and "Recent")  
  - **All**: Show everyone (unchanged)
  - **Simplified Logic**: Reduced from 5 categories to 3 for cleaner filtering
  - **Better UX**: More intuitive category names that reflect actual dance frequency
  - **Consistent Implementation**: Updated across all filtering components

### Technical
- Updated `ActivityLevel` enum in `dancer_activity_service.dart` to use new categories
- Modified `DancerActivityService` filtering logic to use new time periods and thresholds
- Updated display names and descriptions in `activity_filter_widget.dart`
- Updated `combined_dancer_filter.dart` to use new activity levels
- Updated `simplified_tag_filter.dart` activity level options
- Changed default activity level from "Active" to "Regular" for better user experience
- Applied proper Dart formatting to all modified files

## [v1.3.7] - 2025-01-17
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "The dialog from the planning tab" - Request to update the Select Dancers dialog from the Planning tab to use the SimplifiedTagFilter component
- "Now reuse it on Dancers screen" - Request to update the Dancers screen to use SimplifiedTagFilter component

### Changed
- **Select Dancers Dialog**: Updated to use SimplifiedTagFilter component instead of CommonFilterSection
  - **Consistent Tag Filtering**: Now uses the same tag filtering component as other screens
  - **Integrated Search**: Removed separate search field, now uses built-in search from SimplifiedTagFilter
  - **Cleaner UI**: Single component handles both search and tag filtering
  - **Better UX**: More intuitive tag selection with visual feedback
  - **Code Consistency**: Aligns with other screens using SimplifiedTagFilter
- **Dancers Screen**: Updated to use SimplifiedTagFilter component instead of CombinedDancerFilter
  - **Consistent Tag Filtering**: Now uses the same tag filtering component as other screens
  - **Integrated Search**: Uses built-in search from SimplifiedTagFilter
  - **Simplified State Management**: Removed activity level filtering and related complexity
  - **Better UX**: More streamlined filtering experience
  - **Code Consistency**: Aligns with other screens using SimplifiedTagFilter

### Technical
- Updated `lib/screens/event/dialogs/select_dancers_screen.dart` to use SimplifiedTagFilter
- Updated `lib/screens/dancers/dancers_screen.dart` to use SimplifiedTagFilter
- Removed separate search field, now uses integrated search from SimplifiedTagFilter
- Removed unused TextEditingController and simplified state management
- Removed activity level filtering complexity from Dancers screen
- Maintained existing functionality while improving component consistency
- Applied proper Dart formatting to ensure code quality

## [v1.3.6] - 2025-01-17
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "Nice. I tested and text search does not work" - Request to fix text search functionality in Add Existing Dancer dialog
- "Something is off with the text search, it looses focus after writing a letter and puts next letter at first position" - Request to fix text search focus issue
- "I get late initialization for searchController" - Request to fix late initialization error

### Fixed
- **Text Search Functionality**: Fixed text search in Add Existing Dancer dialog
  - **Search Integration**: Connected search callback to filtering logic in AddExistingDancerScreen
  - **Real-Time Filtering**: Search now properly filters dancers by name and notes
  - **Combined Filtering**: Search works together with tag filtering for comprehensive results
  - **Proper State Management**: Added search query state and callback handling
- **Text Field Focus Issue**: Fixed text field losing focus during typing
  - **Persistent Controller**: Used persistent TextEditingController instead of creating new one on each build
  - **Proper Initialization**: Fixed late initialization error with proper controller setup
  - **Focus Retention**: Text field now maintains focus and cursor position while typing
  - **Debounced Search**: 300ms debounce prevents excessive API calls during typing

### Technical
- **AddExistingDancerScreen**: Added search state management and callback handling
- **SimplifiedTagFilter**: Fixed TextEditingController initialization and disposal
- **DancerFilterService**: Integrated text filtering with existing tag filtering logic
- **State Management**: Added proper search query state and rebuild triggers
- **Performance**: Implemented debounced search to avoid excessive filtering operations

## [v1.3.5] - 2025-07-05
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

## [v1.3.4] - 2025-01-17
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "remove dancer from planned event action" - Request to add ability to remove dancers from planned events

### Added
- **Remove from Event Action**: Added ability to remove dancers from planned events in the planning tab
  - **Planning Mode Only**: Available only in planning mode for dancers who have rankings
  - **Context Menu Action**: "Remove from Event" option in dancer actions dialog
  - **Ranking Deletion**: Removes the dancer's ranking and planning data from the event
  - **User Feedback**: Success/error toast messages with dancer name
  - **Past Event Protection**: Not available for past events to preserve historical data
  - **Action Logging**: Comprehensive logging for remove operations

### Technical
- Added `_removeFromEvent()` method to DancerActionsDialog
- Used RankingService.deleteRanking() to remove dancer rankings
- Added proper error handling and user feedback
- Integrated with existing action logging system
- Applied proper Dart formatting for code quality

## [v1.3.0] - 2025-01-16
## [v1.5.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "1" - Request to implement dancer archival feature

### Added
- **Dancer Archival System**: Complete backend implementation for archiving inactive dancers
  - **Database Schema**: Added `isArchived` (boolean) and `archivedAt` (datetime) fields to dancers table
  - **Archival Methods**: `archiveDancer()`, `reactivateDancer()`, `getArchivedDancers()` in DancerCrudService
  - **Active-Only Streams**: `watchActiveDancers()`, `searchActiveDancers()`, `getActiveDancersWithTags()` methods
  - **Service Layer Integration**: Updated DancerService, DancerSearchService, and DancerTagService with archival support
  - **Data Preservation**: All dance history, rankings, scores, and relationships remain intact when archiving
  - **Reversible Operations**: Archived dancers can be easily reactivated with one method call

### Technical
- **Database Migration**: Added new columns with proper defaults (existing dancers remain active)
- **Service Architecture**: Implemented archival methods across all dancer-related services
- **Stream Filtering**: Added active-only streams that automatically exclude archived dancers
- **Search Integration**: Active-only search functionality for cleaner event planning
- **Tag Service Updates**: Active-only tag filtering for better community management
- **Action Logging**: Comprehensive logging for all archival operations
- **Error Handling**: Proper error handling and validation for archival operations

### Documentation
- **Technical Specification**: Updated `specs/technical/technical_DancerArchival.md` with implementation status
- **Service Layer Documentation**: Documented all new archival methods and active-only streams
- **Migration Strategy**: Marked Phase 1 (Database) and Phase 2 (Service Layer) as completed
