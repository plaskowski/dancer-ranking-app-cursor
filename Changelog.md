# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v1.4.6] - 2025-01-17

### User Requests
- "I have reverted ScoreDialog latest changes (commit). Now try simplify it to simple sheet with one tap options" - Request to simplify ScoreDialog to basic one-tap options
- "remove last updated from edit rank dialog" - Request to remove last updated info from RankingDialog

### Changed
- **ScoreDialog Simplification**: Reverted to simple one-tap design
  - **Simple ListTile**: Uses basic ListTile with circle icons for selection
  - **One-Tap Selection**: Tap any score to immediately assign it
  - **Minimal UI**: Just dancer name, score list, and cancel button
  - **No Complex Structure**: Removed RadioListTile, action buttons, and sections
  - **Direct Assignment**: Score is assigned immediately on tap
- **RankingDialog Cleanup**: Removed last updated information
  - **Simplified UI**: Removed "Last updated" timestamp display
  - **Cleaner Layout**: Less visual clutter in the dialog
  - **Removed Dependencies**: No longer imports intl package for date formatting

### Technical
- **ScoreDialog**: Reverted to original simple structure with one-tap assignment
- **RankingDialog**: Removed _lastUpdated variable and related UI elements
- **UI Consistency**: Both dialogs now have appropriate complexity for their use cases
- **Code Cleanup**: Removed unnecessary imports and variables

## [v1.4.5] - 2025-01-17

### User Requests
- "Why the assign score sheet looks different from other sheets?" - Request to understand and fix UI inconsistency in ScoreDialog

### Improved
- **ScoreDialog UI Consistency**: Updated ScoreDialog to match RankingDialog's structure and styling
  - **Consistent Layout**: Now uses same header, sections, and action button layout as RankingDialog
  - **RadioListTile Selection**: Replaced ListTile with RadioListTile for better selection UX
  - **Proper Action Buttons**: Added Cancel and Set Score buttons with loading states
  - **Better Visual Hierarchy**: Improved spacing, typography, and section organization
  - **Static Show Method**: Added `ScoreDialog.show()` static method for consistent presentation
  - **Loading States**: Added proper loading indicators during save operations

### Technical
- **ScoreDialog**: Completely refactored to match RankingDialog architecture
- **Static Show Method**: Added `ScoreDialog.show()` for consistent modal presentation
- **RadioListTile**: Replaced simple ListTile with RadioListTile for better selection UX
- **Action Buttons**: Added proper Cancel/Save button layout with loading states
- **UI Consistency**: All dialog components now follow same design patterns

## [v1.4.4] - 2025-01-17

### User Requests
- "All good now, commit" - Request to commit the real-time filtering improvements

### Improved
- **Real-Time Dancer Filtering**: Enhanced dancer filtering to use streams for live updates
  - **Dancers Screen**: Converted from Future to Stream for real-time dancer list updates
  - **Base Dancer Selection**: Updated base class to support streaming data for live filtering
  - **Immediate Updates**: Dancer lists now update immediately when data changes
  - **Better Performance**: Reduced unnecessary rebuilds with streaming approach
  - **Consistent Architecture**: All dancer filtering now uses same streaming pattern

### Technical
- **DancersScreen**: Updated `_getDancers` method to return Stream instead of Future
- **BaseDancerSelectionScreen**: Updated base class to support streaming data sources
- **DancerListFilterWidget**: Converted from FutureBuilder to StreamBuilder for real-time updates
- **Streaming Architecture**: Consistent use of streams across all dancer filtering components
- **Performance Optimization**: Real-time updates without manual refresh requirements

## [v1.4.3] - 2025-01-17

### User Requests
- "Now try use the base class to rewrite @dancers_screen.dart" - Request to refactor Dancers screen to use base class for better code organization

### Changed
- **Dancers Screen**: Completely refactored to use new BaseDancerListScreen
  - **Code Reduction**: Reduced from 267 lines to 95 lines (65% reduction)
  - **Base Class Architecture**: Created generic BaseDancerListScreen for general dancer management
  - **Consistent Filtering**: Now uses same SimplifiedTagFilter component as other screens
  - **Maintained Functionality**: All existing features preserved (edit, delete, merge, add dancer)
  - **Better Code Organization**: Separated concerns between base component and specific implementation
  - **Improved Maintainability**: Common filtering logic now centralized in base component
  - **Consistent UX**: Same filtering patterns and empty states as other screens

### Technical
- **BaseDancerListScreen**: Created new generic base class for general dancer list screens
- **DancerListFilterWidget**: Added reusable filtering and list display widget
- **DancersScreen**: Refactored to use base class while maintaining all specific functionality
- **Code Architecture**: Improved separation between event-specific and general dancer management
- **Consistent Patterns**: All dancer list screens now use same base architecture

## [v1.4.2] - 2025-01-17

### User Requests
- "move mixin to parent class" - Request to move EventDancerSelectionMixin to base class for better code organization
- "Have same screen title" - Request to fix duplicate screen titles between dancer selection screens
- "The select dancers dialog shoud not close after first row action" - Request to allow multiple selections without closing dialog

### Changed
- **Dancer Selection Screens**: Improved code organization and user experience
  - **Mixin Refactoring**: Moved EventDancerSelectionMixin to BaseDancerSelectionScreen for better code reuse
  - **Unique Screen Titles**: Updated titles to be more descriptive and distinct
    - "Add Dancers to Event" for Select Dancers screen
    - "Mark Dancers Present" for Add Existing Dancer screen
  - **Multi-Selection Support**: Select Dancers screen now stays open for multiple selections
  - **Better UX**: Users can add multiple dancers without reopening the dialog
  - **Consistent Behavior**: Both screens maintain their specific success messages and refresh functionality

### Technical
- **BaseDancerSelectionScreen**: Added EventDancerSelectionMixin to base class for common functionality
- **SelectDancersScreen**: Removed mixin duplication, updated title, disabled auto-close
- **AddExistingDancerScreen**: Removed mixin duplication, updated title for clarity
- **Code Organization**: Reduced duplication while maintaining specific functionality per screen
- **User Experience**: Improved multi-selection workflow for event planning

## [v1.4.1] - 2025-01-17

### User Requests
- "Start again and try step by step. Let's use Add Existing Dancer screen as the template. Extract a base component from it for now." - Request to create a reusable base component from the Add Existing Dancer screen

### Added
- **DancerFilterListWidget**: Created reusable base component for dancer filtering and list display
  - **Common Filtering Logic**: Extracted tag filtering and search functionality into reusable widget
  - **Flexible Data Source**: Configurable function to get dancers based on filters
  - **Customizable UI**: Configurable title, info message, and dancer tile builder
  - **Empty State Handling**: Optional custom empty state builder for specialized displays
  - **Info Banner Control**: Optional info banner display for context-specific messages
  - **Consistent UX**: Standardized loading states, error handling, and empty states

### Changed
- **Add Existing Dancer Screen**: Refactored to use new DancerFilterListWidget base component
  - **Simplified Implementation**: Reduced from 248 lines to 89 lines (64% reduction)
  - **Maintained Functionality**: All existing features preserved (tag filtering, search, mark present)
  - **Better Code Organization**: Separated concerns between base component and specific implementation
  - **Improved Maintainability**: Common filtering logic now centralized in base component
  - **Consistent Behavior**: Uses same filtering patterns as other screens

### Technical
- Created `lib/widgets/dancer_filter_list_widget.dart` with reusable filtering and list display logic
- Refactored `lib/screens/event/dialogs/add_existing_dancer_screen.dart` to use base component
- Maintained all existing functionality while improving code organization
- Applied proper Dart formatting and ensured no compilation errors
- Base component designed for future reuse across other dancer list screens

## [v1.4.0] - 2025-01-17

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

### User Requests
- Release build and upload

### Added
- Automated release process

### Technical
- Release script for version bumping and APK distribution

## [v1.3.4] - 2025-01-17

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

## [v0.9.4] - 2025-01-27

### User Requests
- "add CLI arg value to open that screen" - Added CLI navigation for Select Dancers screen
- "I don't have a back button, I want to be able to navigate back to planning tab" - Added back button navigation
- "great, commit" - Confirmed all features working

### Added
- **CLI Navigation for Select Dancers**: Added new CLI action to open Select Dancers screen directly
  - New path: `/event/current/planning-tab/select-dancers`
  - Direct navigation to Select Dancers screen with proper context
  - Updated CLI help documentation with new action
- **Back Button Navigation**: Added back button to Select Dancers screen
  - Navigates back to EventScreen with planning tab active
  - Preserves event context and tab selection
  - Seamless user experience with proper navigation flow

### Improved
- **Reactive Template Pattern**: Applied reactive updates to Select Dancers screen
  - Added refresh key mechanism for immediate UI updates
  - Dancers disappear from list when added to event
  - Real-time feedback for user actions
  - Consistent with Add Existing Dancer dialog behavior

## [v0.9.3] - 2025-01-27

### User Requests
- "I mean in Existing Dancers dialog on present tab" - Fixed reactive updates in Add Existing Dancer dialog
- "stop, use reactive approach" - Implemented proper reactive solution
- "All good, commit" - Confirmed reactive updates are working

### Added
- **Reactive Updates**: Implemented reactive approach for Add Existing Dancer dialog
  - Added refresh key mechanism to trigger UI updates when data changes
  - Updated DancerFilterListWidget to support refresh key parameter
  - Rows now disappear immediately when dancers are marked as present
  - Improved user experience with real-time feedback

## [v0.9.2] - 2025-01-27

### User Requests
- "Check the logs. It still opens the dialog many times" - Fixed multiple CLI action executions
- "works, commit" - Confirmed fix is working

### Fixed
- **CLI Action Execution**: Prevented multiple executions of CLI actions during widget rebuilds
  - Added execution flag in PresentTab to track if CLI action has already been executed
  - Removed duplicate CLI action handling from EventScreen
  - Improved separation of concerns between EventScreen and PresentTab
  - CLI actions now execute only once per navigation, preventing dialog spam

## [v0.9.1] - 2025-01-27

### User Requests
- "use Audit Log approach" - Replaced print statements with proper ActionLogger calls for CLI navigation tracking

### Technical
- **CLI Navigation Audit Logging**: Replaced all print statements in CLI navigation flow with structured ActionLogger calls
  - Updated `cli_navigation.dart` to use ActionLogger for navigation tracking
  - Updated `event_screen.dart` to log CLI action handling
  - Updated `present_tab.dart` to log CLI action execution
  - Updated `home_navigation_service.dart` to log navigation events
  - Improved debugging and tracking capabilities for CLI navigation flow
  - Better error tracking and context preservation for troubleshooting

## [v0.9.0] - 2025-01-27
