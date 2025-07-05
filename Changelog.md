# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.3.7] - 2025-01-17
## [v1.4.0] - 2025-07-05

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
## [v1.4.0] - 2025-07-05

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
## [v1.4.0] - 2025-07-05

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
## [v1.4.0] - 2025-07-05

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
