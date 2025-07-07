# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v2.2.3] - 2025-01-17

### User Requests
- Hide "Mark Present" action in planning tab if the event is a future one

### Improved
- **Future Event Logic**: Enhanced "Mark Present" action visibility for better UX
  - **Hide for Future Events**: "Mark Present" action now hidden for events scheduled after today
  - **Prevent Invalid Actions**: Users can no longer mark presence for events that haven't happened yet
  - **Logical Workflow**: Maintains presence marking only for current day events
  - **Better Planning UX**: Planning tab now focuses on ranking and preparation for future events
  - **Consistent Behavior**: Aligns with existing logic that hides action for past events

### Technical
- **EventStatusHelper**: Added `isFutureEvent()` method to match existing `isPastEvent()` pattern
- **DancerActionsDialog**: Used EventStatusHelper for consistent date logic across the app
- **Date Logic**: Leverages existing helper class architecture for event date comparisons
- **Action Logging**: Enhanced logging to track both past and future event status
- **Conditional Display**: "Mark Present" only appears when `!isPastEvent && !isFutureEvent` (today only)

## [v2.2.2] - 2025-01-17

### User Requests
- At present tab move the score as text after the dance impression (maybe bold it)
- add a note character for impression and star character for score but switch them so that score goes before impression. Make the score the same color as impressioon.
- I changed my mind. Remove the note and star. Also, on summary tab don't show the score in the card

### Changed
- **Score Display Enhancement**: Improved score and impression presentation across tabs
  - **Clean Text Display**: Removed star and note characters for cleaner appearance
  - **Score Before Impression**: Score appears before impression for better information flow
  - **Unified Color Scheme**: Score and impression use the same color for visual consistency
  - **Score as Bold Text**: Score appears as bold text instead of as a separate pill
  - **Summary Tab Optimization**: Score hidden on summary tab to reduce visual clutter
  - **Planning Tab Unchanged**: Score pill remains in Planning tab for visual emphasis during planning
  - **Better UX**: Clean, readable display with logical information order

### Technical
- **DancerCard Widget**: Modified to show score before impression without visual icons
- **Summary Tab Logic**: Added `!isSummaryMode` condition to hide score text on summary tab
- **Color Unification**: Both score and impression use danceAccent color theme
- **Conditional Display**: Score pill only appears in planning mode, formatted text appears in present mode (but not summary mode)

## [v2.2.1] - 2025-01-17

### User Requests
- Dance history screen is obscured by system bottom bar

### Fixed
- **Dance History Screen Layout**: Fixed issue where content was obscured by system bottom bar
  - **SafeArea Implementation**: Wrapped body content in SafeArea widget to respect system UI insets
  - **Bottom Content Visibility**: Last items in dance history are now fully visible above system navigation
  - **Cross-Platform Compatibility**: Ensures proper layout on both iOS and Android devices
  - **User Experience**: Users can now access all dance history content without scrolling conflicts

### Technical
- **UI Layout Fix**: Added SafeArea wrapper to DancerHistoryScreen body
- **System UI Respect**: Proper handling of system bottom navigation and home indicator areas
- **Content Accessibility**: Ensures all content is within safe viewing area

## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

## [v2.1.0] - 2025-01-17

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

## [v1.3.9] - 2025-01-17

### User Requests
- "fix" - Request to fix issue where dancers added to future events appear on present tab but not planning tab

### Fixed
- **Planning Tab Dancer Display**: Fixed issue where dancers added through Planning tab appeared on Present tab instead of Planning tab
  - **Correct Behavior**: Dancers added through Planning tab now appear in Planning tab with neutral ranking
  - **Proper Workflow**: Planning tab adds dancers with neutral ranking (not marked as present)
  - **Tab Separation**: Planning tab shows ranked dancers who are not present, Present tab shows only present dancers
  - **User Experience**: Dancers can now be properly planned and ranked before being marked as present
  - **Consistent Logic**: Aligns with intended workflow where Planning tab is for preparation, Present tab is for attendance

### Technical
- **SelectDancersScreen**: Modified to add rankings instead of marking dancers as present
  - **RankingService Integration**: Now uses `setRankNeutral()` instead of `markPresent()`
  - **Neutral Ranking**: Dancers get ordinal 3 (neutral) ranking by default
  - **Proper Imports**: Added RankingService import for ranking operations
  - **Updated Messages**: Changed success message to reflect neutral ranking assignment
- **Database Logic**: Maintains proper separation between rankings and attendance records
  - **Planning Tab Filter**: Shows dancers with `hasRanking && !isPresent`
  - **Present Tab Filter**: Shows dancers with `status == 'present' || status == 'served'`
  - **Workflow Clarity**: Clear distinction between planning (ranking) and attendance (presence)

## [v1.3.8] - 2025-01-17

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "when splitting the history put the dancer name first" - Request to change the naming format for extracted dance records

### Changed
- **Extract Dance Record Naming**: Updated naming format for extracted one-time persons
  - **Before**: "[EventName] - [OriginalDancerName]"
  - **After**: "[OriginalDancerName] - [EventName]"
  - **Service**: Updated `DancerExtractionService.extractDanceRecordAsOneTimePerson()` method
  - **Documentation**: Updated feature specification to reflect new naming convention

### Technical
- **Naming Convention**: Dancer name now appears first in extracted record names for better identification
- **Consistency**: Aligns with user preference for dancer-centric naming

## [v2.0.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- "bump @pubspec.yaml and @Changelog.md version to 2.0" - Request to update version to 2.0.0

### Changed
- **Version Bump**: Updated version from 1.6.0 to 2.0.0
  - **pubspec.yaml**: Updated version to 2.0.0+200
  - **Changelog.md**: Updated version header to v2.0.0

### Technical
- **Version Management**: Manual version bump to 2.0.0 for major release
- **Android Version Code**: Updated to 200 (2.0.0 without dots)

## [v1.5.7] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "Drop latest commit. You were supposed to reorder dancer actions on Planning and Present tab" - Request to reorder dancer context menu actions

### Changed
- **Dancer Actions Dialog**: Reordered actions by frequency of use for better UX
  - **Most Common First**: Mark Present/Absent moved to top
  - **Second Most Common**: Assign/Edit Score moved to second position
  - **Third Most Common**: Set/Change Ranking moved to third position
  - **Less Common Actions**: Record Dance, View History, Edit, etc. moved to bottom
- **Removed Unused Action**: Removed "Mark Present & Record Dance" action since absent dancers aren't shown in Present tab
- **Documentation Updates**: Updated Product specification to reflect new action order

### Technical
- **UX Optimization**: Most frequently used actions now appear first in context menu
- **Better Workflow**: Reduces scrolling and improves efficiency for common tasks

## [v1.5.6] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

### Documentation
- Updated Product specification.md to reflect new bottom sheet presentation for ranking and score pickers


### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- "Let's try this" - Request to implement extract historical dance record as one-time person feature
- "use regular tap" - Request to use tap instead of long press for extraction action
- "add the dancer name to the new one-time dancer name" - Request to include original dancer name in extracted person name
- "finish" - Request to complete the implementation

### Added
- **Extract Historical Dance Record Feature**: Complete implementation for separating dance records as one-time persons
  - **Service Layer**: New `DancerExtractionService` with database transaction handling
  - **UI Dialog**: `ExtractDanceRecordDialog` with confirmation, loading states, and error handling
  - **Context Menu**: Tap on dance records in dancer history to access "Separate record" option
  - **Data Model Updates**: Enhanced `DancerRecentHistory` to include attendance ID for extraction
  - **Naming Convention**: New one-time persons named "[OriginalDancerName] - [EventName]"

### Technical
- **Database Operations**: Safe transaction-based extraction with proper error handling
- **UI Integration**: Context menu in dancer history screen with proper data flow
- **Data Integrity**: Preserves all dance data while removing from original dancer
- **Audit Logging**: Comprehensive logging for all extraction operations

## [v1.5.5] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- "dancer merge action has shown and error, @dart" - Request to fix dancer merge constraint error

### Fixed
- **Dancer Merge Constraint Error**: Fixed UNIQUE constraint violation when merging dancers with duplicate rankings
  - **Rankings Update Logic**: Added proper duplicate handling for rankings table
  - **Safe Updates**: Only update rankings from source to target if target doesn't already have ranking for that event
  - **Duplicate Cleanup**: Delete source rankings for events where target already has a ranking
  - **Consistent Pattern**: Applied same logic pattern already used for attendances

### Technical
- **Database Constraints**: Proper handling of unique constraints in merge operations
- **Data Integrity**: Ensures no duplicate rankings per dancer per event during merges
- **Error Prevention**: Prevents constraint violations in dancer merge operations

## [v1.5.4] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- "on Dancers screen, in a row, put the notes in a new line (if they are not empty), and the last seen to span whole width of the row" - Request to improve dancer card layout

### Improved
- **Dancer Card Layout**: Enhanced dancer card layout in Dancers screen
  - **Notes on New Line**: Moved dancer notes to separate line below last seen info
  - **Full Width Last Seen**: Last seen event info now spans the full width of the row
  - **Better Spacing**: Improved spacing between elements for cleaner visual hierarchy
  - **Removed Divider**: Eliminated vertical divider since notes and last seen are now separate

### Technical
- **Layout Optimization**: Restructured dancer card subtitle layout for better readability
- **UI Consistency**: Improved visual hierarchy in dancer list display

## [v1.5.2] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "this" - Request to fix double border issue in text search fields
- "make @release.sh script bump the pubspec version too" - Request to ensure release script updates pubspec version
- "@dancers_screen.dart should be more aligned with @add_existing_dancer_screen.dart" - Request to align dancers screen with cleaner pattern
- "Support /dancers path for CLI arg" - Request to add CLI navigation support for dancers screen
- "the text search field in Dancers screen has 2 outlines" - Request to fix double border issue in dancers screen
- "Great, but now it has different outline than the tag filter" - Request to make search field outline consistent with filter buttons
- "still no good" - Request to fix corner clipping issue in text field
- "make it less tall to have the same height as the tag filter button" - Request to adjust text field height
- "all good, commit" - Request to commit all changes

### Fixed
- **Double Border Issue**: Fixed text search fields having two borders due to global theme + local border conflicts
  - **CommonSearchField**: Removed explicit `border: OutlineInputBorder()` to use global theme
  - **AddDancerDialog**: Removed explicit border declaration for notes field
  - **DanceRecordingDialog**: Removed explicit border declaration for impression field
  - **CompactDancerFilter**: Removed explicit border declaration for search field
  - **TagSelectionFlyout**: Removed explicit border declaration for search field
  - **SelectMergeTargetScreen**: Removed explicit border declaration for search field
- **Dancers Screen Alignment**: Refactored dancers screen to follow cleaner pattern like add_existing_dancer_screen
  - **Async/Await Pattern**: Converted all methods to use proper `Future<void>` with async/await
  - **Cleaner Dialog Handling**: Delete confirmation now returns boolean instead of inline logic
  - **Better Separation**: Business logic separated from UI logic
  - **Info Message**: Added helpful context message like other screens
  - **Consistent Error Handling**: More consistent with pattern used in other screens
- **CLI Navigation Support**: Added support for `/dancers` path in CLI navigation
  - **Help Documentation**: Updated CLI help to include dancers path and examples
  - **Navigation Logic**: Added dancers screen navigation in CLI navigator
  - **Import Support**: Added proper import for DancersScreen
  - **Path Resolution**: Updated path resolution to handle non-event screens
- **Search Field Consistency**: Fixed search field outline and height consistency in dancers screen
  - **Theme Colors**: Changed from hardcoded grey to theme-based outline colors
  - **Native Borders**: Switched from custom container to TextField's native border system
  - **Height Matching**: Added height constraint to match filter button height (40px)
  - **Corner Clipping**: Fixed corner clipping issues with proper border implementation
  - **Content Padding**: Adjusted padding for compact appearance

### Improved
- **Release Script**: Enhanced release script with better error handling and validation
  - **Help Support**: Added proper `--help` and `-h` flag support
  - **Robust Validation**: Added version format validation and backup/restore functionality
  - **Better Documentation**: Enhanced help text with detailed usage examples
  - **Error Recovery**: Added backup creation and restoration for failed updates

### Technical
- **Border System**: Unified border handling across all text fields using global theme
- **CLI Architecture**: Extended CLI navigation to support non-event screens
- **UI Consistency**: Standardized search field appearance across all screens
- **Code Quality**: Improved async handling and error management patterns

## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution





### User Requests
- "I feel like we now have many such simple dialogs, extract common component for that." - Request to create reusable component for simple selection dialogs

### Added
- **SimpleSelectionDialog Component**: New reusable component for simple selection dialogs
  - **Generic Design**: Supports any type of items with customizable title and selection logic
  - **One-Tap Selection**: Immediate selection with visual feedback (check_circle vs circle_outlined)
  - **Built-in Logging**: Automatic action logging with configurable prefix
  - **Loading States**: Built-in loading indicator support
  - **Consistent UI**: Standardized header, list, and cancel button layout
  - **Error Handling**: Proper error handling and user feedback

### Refactored
- **ScoreDialog**: Refactored to use SimpleSelectionDialog component
  - **Reduced Code**: Eliminated duplicate UI code by 70%
  - **Consistent Behavior**: Maintains same functionality with cleaner implementation
  - **Better Maintainability**: Easier to modify and extend
- **Scores Management Merge Dialog**: Refactored merge target selection to use SimpleSelectionDialog
  - **Simplified Logic**: Cleaner dialog presentation and selection handling
  - **Consistent UX**: Same visual pattern as other selection dialogs

### Technical
- **Component Reusability**: Created generic SimpleSelectionDialog<T> for type-safe usage
- **Action Logging**: Integrated logging with configurable prefixes for different dialogs
- **Error Handling**: Proper async error handling with user-friendly messages
- **UI Consistency**: Standardized visual design across all simple selection dialogs

## [v1.4.6] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I have reverted ScoreDialog latest changes (commit). Now try simplify it to simple sheet with one tap options" - Request to simplify ScoreDialog to basic one-tap options
- "remove last updated from edit rank dialog" - Request to remove last updated info from RankingDialog

### Changed
- **ScoreDialog Simplification**: Reverted to simple one-tap design
  - **Simple ListTile**: Uses basic ListTile with circle icons for selection
  - **One-Tap Selection**: Tap any score to immediately assign it
  - **Minimal UI**: Removed complex RadioListTile structure and action buttons
  - **Direct Action**: Score is assigned immediately when you tap it
- **RankingDialog Cleanup**: Removed last updated timestamp display
  - **Cleaner UI**: Removed unnecessary timestamp information
  - **Simplified Layout**: Less visual clutter in the ranking dialog

### Technical
- **UI Consistency**: Ensured appropriate complexity for each dialog's use case
- **Code Simplification**: Reduced complexity where appropriate for better UX

## [v1.4.5] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "Why the assign score sheet looks different from other sheets?" - Request to understand and fix UI inconsistency in ScoreDialog

### Improved
- **ScoreDialog UI Consistency**: Updated ScoreDialog to match RankingDialog's structure and styling
  - **Consistent Layout**: Now uses same header, sections, and action button layout as RankingDialog
  - **RadioListTile Selection**: Replaced ListTile with RadioListTile for better selection UX
  - **Proper Action Buttons**: Added Cancel and Set Score buttons with loading states
  - **Better Visual Hierarchy**: Clear sections with proper spacing and typography
  - **Static Show Method**: Added ScoreDialog.show() for consistent presentation pattern
- **Dialog Presentation**: Updated all ScoreDialog calls to use new static show method
  - **Consistent Pattern**: All dialogs now follow same presentation pattern
  - **Better Integration**: Improved integration with existing dialog flows

### Technical
- **UI Architecture**: Standardized dialog presentation patterns across the app
- **Code Reusability**: Improved consistency between similar dialog components
- **User Experience**: Enhanced visual consistency and interaction patterns

## [v1.4.4] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "All good now, commit" - Request to commit the real-time filtering improvements

### Improved
- **Real-Time Dancer Filtering**: Enhanced dancer filtering to use streams for live updates
  - **Dancers Screen**: Converted from Future to Stream for real-time dancer list updates
  - **Base Dancer Selection**: Updated base class to support streaming data for live filtering
  - **Immediate Updates**: Dancer lists now update automatically when data changes
  - **Better Performance**: Reduced unnecessary rebuilds with streaming approach
  - **Consistent Architecture**: All dancer filtering now uses same streaming pattern

### Technical
- **Streaming Architecture**: Implemented Stream<List<DancerWithTags>> for real-time updates
- **Performance Optimization**: Reduced unnecessary widget rebuilds with streaming approach
- **Code Consistency**: Unified filtering patterns across all dancer selection components

## [v1.4.3] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.2] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
<<<<<<< HEAD
- Created `CombinedDancerFilter` widget for unified filtering experience
- Updated `SimplifiedTagFilter` with improved pill-based selection interface
- Added `ActivityFilterWidget` for activity level filtering
- Integrated activity service with filtering system
- Updated Dancers screen to use new unified filtering approach

### Documentation
- **Material 3 Icons Guide**: Created comprehensive documentation with examples and best practices
- **Implementation Examples**: Added practical examples for navigation, action, and status icons
- **Migration Guide**: Documented process for updating existing icons to Material 3 standards
- **Best Practices**: Established guidelines for icon variant selection and color usage
=======
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.1] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.4.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.3.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.2.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.1.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v1.0.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.9.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.8.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.7.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.6.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.5.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.4.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.3.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.2.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs

## [v0.1.0] - 2025-01-17
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v1.4.8] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.5.3] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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



### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.0.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v1.6.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution


## [v2.1.0] - 2025-07-05
## [v2.2.0] - 2025-07-05

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


## [v[ERROR] Invalid bump type: --help. Use major, minor, or patch] - 2025-07-05

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution



### User Requests
- "I want to see the dancer list in the planning tab" - Request to display dancer list in planning tab

### Added
- **Planning Tab Dancer List**: Added comprehensive dancer list to planning tab
  - **Dancer Cards**: Shows all dancers with their current status and ranking
  - **Status Indicators**: Visual indicators for present/absent status and ranking
  - **Action Buttons**: Quick actions for each dancer (mark present, assign ranking, etc.)
  - **Filtering**: Tag-based filtering to find specific dancers
  - **Search**: Text search to quickly locate dancers by name
  - **Real-time Updates**: List updates automatically when data changes

### Improved
- **Planning Workflow**: Enhanced planning experience with comprehensive dancer management
  - **Quick Actions**: Mark dancers present/absent directly from the list
  - **Ranking Assignment**: Assign rankings without navigating to separate screens
  - **Status Overview**: Clear visual overview of all dancers and their status
  - **Efficient Planning**: Streamlined workflow for event planning

### Technical
- **Reusable Components**: Leveraged existing DancerCard and filtering components
- **Streaming Data**: Real-time updates using StreamBuilder for immediate feedback
- **Consistent UI**: Maintained visual consistency with other tabs
>>>>>>> origin/first-line
