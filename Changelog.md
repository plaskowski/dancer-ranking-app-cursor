# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [v1.3.5] - 2025-01-17

### User Requests
- "still no luck" - Request to fix tag filtering in Add Existing Dancer dialog
- "I wan it in the same line as 'Filter by tags'" - Request to move Clear All button to same line as title
- "Nah, just remove that button" - Request to remove Clear All button from tag filter dialog

### Added
- **Enhanced Tag Filtering**: Improved tag filtering functionality in Add Existing Dancer dialog
  - **Proper Tag Filtering**: Fixed implementation to actually filter dancers by selected tags
  - **DancerWithTags Integration**: Updated to use DancerWithTags model for proper tag information
  - **Multi-Tag Support**: Can filter by multiple tags simultaneously with proper database queries
  - **Real-Time Filtering**: Tag selection immediately filters the dancer list

### Improved
- **DancerFilterService**: Enhanced with new method for tag-based filtering
  - **getAvailableDancersWithTagsForEvent()**: New method that properly filters by tags
  - **Database Integration**: Direct database queries for ranked and present dancer IDs
  - **Tag-Aware Filtering**: Filters unranked/absent dancers by selected tags
  - **Performance**: Efficient queries that combine tag filtering with availability filtering
- **Add Existing Dancer Dialog**: Updated to use proper tag filtering
  - **DancerWithTags Model**: Changed from DancerWithEventInfo to DancerWithTags for tag support
  - **Real-Time Updates**: Tag selection immediately updates the dancer list
  - **Proper Filtering**: Shows only dancers with selected tags who are unranked and absent
- **SimplifiedTagFilter UI**: Cleaner interface without Clear All button
  - **Simplified Layout**: Removed Clear All button for cleaner appearance
  - **Standard Behavior**: Users can deselect tags by tapping them again
  - **Better UX**: Less cluttered interface with standard tag selection behavior

### Technical
- **Database Layer**: Added direct database access in DancerFilterService for efficient queries
- **Model Updates**: Updated Add Existing Dancer dialog to use DancerWithTags instead of DancerWithEventInfo
- **Service Architecture**: Enhanced DancerFilterService with proper tag filtering capabilities
- **UI Simplification**: Removed Clear All button from SimplifiedTagFilter for cleaner interface
- **Import Management**: Added proper imports for DancerWithTags model
- **Error Handling**: Maintained proper error handling and loading states

## [v1.3.4] - 2025-01-17

### User Requests
- "Great, let's implement this" - Request to implement the unified dancer filtering component

### Added
- **Unified Dancer Filtering Component**: Implemented CombinedDancerFilter widget with comprehensive filtering capabilities
  - **Self-Managed State**: Component manages its own search query, tag selection, and activity level state
  - **Unified Interface**: Single component handles search, tag filtering, and activity level filtering
  - **Debounced Search**: 300ms debounce for smooth search experience without excessive API calls
  - **Multi-Tag Selection**: Support for selecting multiple tags with visual feedback
  - **Activity Level Filtering**: Radio button selection for different activity levels (All, Active, Very Active, Core Community, Recent)
  - **Dropdown UI**: Clean dropdown interface for both tag and activity level selection
  - **Visual Feedback**: Clear indication of selected filters with counts and descriptions
  - **Loading States**: Proper loading indicators for tag and activity level data
  - **Clear Functionality**: Easy clearing of tag selections with "Clear All" button

### Improved
- **DancersScreen Integration**: Updated to use new CombinedDancerFilter instead of separate components
  - **Simplified State Management**: Removed individual search and tag state management
  - **Unified Filtering Logic**: Single callback handles all filter changes
  - **Better UX**: Consistent filtering experience across the app
  - **Reduced Code Complexity**: Eliminated duplicate filtering logic
- **Filtering Logic**: Enhanced to support multiple tag selection and activity level filtering
  - **Multi-Tag Support**: Can filter by multiple tags simultaneously
  - **Activity Level Integration**: Ready for activity level filtering when service is implemented
  - **Future-Proof Design**: Architecture supports upcoming activity level filtering features

### Technical
- Created `lib/widgets/combined_dancer_filter.dart` with comprehensive filtering functionality
- Updated `lib/screens/dancers/dancers_screen.dart` to use new unified filtering component
- Added proper imports for ActivityLevel enum and TagService
- Implemented debounced search with Timer for performance optimization
- Added loading states and error handling for tag and activity level data
- Maintained existing functionality while improving code organization
- Applied proper Dart formatting to all modified files

## [v1.3.3] - 2025-01-17

### User Requests
- "Try extract a common component for the same" - Request to extract common components for filtering functionality

### Added
- **Common Filter Components**: Extracted reusable components for consistent filtering across screens
  - **CommonSearchField**: Reusable search field with consistent styling, clear button, and behavior
  - **CommonFilterSection**: Combined search and tag filtering component for unified filtering UI
  - **Consistent Styling**: Material 3 design with proper theming and accessibility
  - **Flexible Configuration**: Support for different hint texts, labels, and optional tag filtering
  - **Clear Button Integration**: Built-in clear functionality with proper state management

### Improved
- **Code Reusability**: Reduced code duplication across multiple screens
  - **DancersScreen**: Updated to use CommonFilterSection instead of separate search and tag components
  - **SelectDancersScreen**: Refactored to use unified filtering component
  - **Consistent UX**: All filtering screens now have identical behavior and appearance
  - **Maintainability**: Centralized filtering logic for easier updates and bug fixes

### Technical
- Created `lib/widgets/common_search_field.dart` with comprehensive search field functionality
- Created `lib/widgets/common_filter_section.dart` that combines search and tag filtering
- Updated import statements and component usage across multiple screens
- Maintained existing functionality while improving code organization
- Applied proper Dart formatting to all modified files

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

## [v1.3.1] - 2025-01-17

### User Requests
- "The implementation does not look like the wireframes. The pickers show appear at the bottom, similar to context actions menu" - Request to make ranking and score pickers appear as bottom sheets at the bottom of the screen, matching the wireframes and context menu style

### Changed
- **RankingDialog and ScoreDialog Presentation**: Both dialogs now use showModalBottomSheet and appear as bottom sheets at the bottom of the screen, matching the context actions menu and wireframes
- **UI Consistency**: Picker dialogs now visually match the context actions menu for a more consistent and modern user experience

### Improved
- **Material 3 Bottom Sheet Style**: Ranking and score pickers now use Material 3 bottom sheet style for better UX and platform consistency

### Technical
- Refactored RankingDialog and ScoreDialog to be used as widgets inside showModalBottomSheet
- Updated DancerActionsDialog to launch pickers as bottom sheets instead of AlertDialogs

### Documentation
- Updated Product specification.md to reflect new bottom sheet presentation for ranking and score pickers

## [v1.3.2] - 2025-01-17

### User Requests
- "have similar filtering in add dancers dialog" - Request to add tag filtering functionality to the Add Dancer Dialog, similar to the Select Dancers and Add Existing Dancer screens

### Added
- **Tag Filtering in Add Dancer Dialog**: Added tag-based filtering to help users find existing dancers when creating new dancers
  - **Filter by Tag**: Users can select a tag to filter existing dancers by venue/context
  - **Existing Dancer Selection**: Shows list of existing dancers with the selected tag
  - **Pre-fill Form**: Selecting an existing dancer pre-fills the name, notes, and tags
  - **Duplicate Prevention**: Helps users avoid creating duplicate dancer profiles when they can't remember names
  - **Memory Aid**: Useful when users remember where they know someone from but not their name

### Technical
- Added TagFilterChips widget integration to AddDancerDialog
- Implemented filtered dancer loading and display logic
- Added existing dancer selection functionality with form pre-filling
- Maintained existing tag selection functionality for new dancers

### Documentation
- Updated Product specification.md to reflect new tag filtering functionality in Add Dancer Dialog

## [v1.2.1] - 2025-01-16

### User Requests
- "remove checkmarks from rows in summary tab for past events, at that point I will remember who I danced with after the scores assignment" - Request to hide dance checkmarks for past events in summary tab

### Improved
- **Summary Tab Checkmark Logic**: Removed dance checkmarks (✓) from summary tab for past events
  - **Past Event Detection**: Uses EventStatusHelper to determine if an event is in the past
  - **Cleaner Summary View**: Past events no longer show checkmarks, reducing visual clutter
  - **Better Memory Aid**: Users can focus on scores and impressions without checkmark distraction
  - **Context-Aware Display**: Checkmarks still appear for current and future events
  - **Proper Architecture**: Business logic decision made at SummaryTab level, not DancerCard level

### Technical
- Added hideCheckmark parameter to DancerCard widget for conditional checkmark display
- Modified SummaryTab to fetch event date and determine if event is past
- Used EventStatusHelper.isPastEvent() for consistent past event detection
- Added proper action logging for past event detection in summary tab
- Maintained existing functionality for current and future events

## [v1.2.0] - 2025-01-16

### User Requests
- "Now let's design a new feature - on the list of dancers to be added filter them out by their recency and frequent attendance. Allow me to switch to a broarder scope." - Request for dancer filtering feature design
- "Still too complex. Try combine the two criterias." - Request to simplify the filtering approach
- "The user scenarios do not match my case: I have long history and some of the dancers don't come anymore or come very rarely" - Request to update scenarios for real-world long history context
- "update the spec file" - Request to update the feature specification

### Added
- **Dancer Filtering Feature Design**: Comprehensive design for filtering dancers by activity level
  - **Simplified Approach**: Combined recency and frequency into single "Activity Level" filter
  - **Real-World Scenarios**: Updated user scenarios to reflect long dance history with inactive dancers
  - **Activity Levels**: 5 intuitive levels (All, Active, Very Active, Core Community, Recent)
  - **Smart Defaults**: Context-aware filtering based on event type
  - **Long History Support**: Designed for 200+ dancers with only 30-40 currently active
  - **Legacy Dancer Handling**: Balance current community with historical relationships

### Improved
- **User Experience Design**: Simplified from complex dual-filter to single dropdown approach
- **User Scenarios**: Updated to reflect real-world challenges of managing long dance history
  - **Weekly Social**: Avoid scrolling through 160+ inactive dancers
  - **Monthly Events**: Distinguish between truly active vs. occasional attendees
  - **Festival Planning**: Balance current regulars with legacy dancers
  - **Class Planning**: Focus on current students, avoid inactive former students
  - **Last-Minute Events**: Target currently active dancers for reliable attendance
- **Activity Level Definitions**: Clear criteria for each level with real-world use cases
- **Implementation Timeline**: Reduced from 6-10 weeks to 2-3 weeks total

### Documentation
- **Feature Design**: `specs/features/feature_DancerFiltering.md` - Complete feature specification
- **User Scenarios**: Real-world examples with long dance history context
- **Activity Level Definitions**: Clear criteria and use cases for each filter level
- **Implementation Strategy**: Simplified 2-phase approach with faster timeline

## [v1.1.1] - 2025-01-16

### User Requests
- "when importing event, looking for existing dancer with given name, try lookup few different variants to better match" - Request to improve dancer name matching during event import
- "try also: switching places of words (for two word names), removing or adding a dot at the and, replacing diacretic characters with their base characters" - Request for additional name matching strategies
- "Now please write a test that covers this new logic" - Request for comprehensive test coverage

### Improved
- **Enhanced Dancer Name Matching**: Improved event import to try different name variants for better dancer matching
  - **Multiple Variants**: Tries exact match, lowercase, title case, and different capitalization patterns
  - **Space Normalization**: Handles extra spaces, single space normalization, and trimming
  - **Case Variations**: Supports different case combinations for multi-word names
  - **Word Order Switching**: For two-word names, tries both word orders (e.g., "John Doe" ↔ "Doe John")
  - **Dot Handling**: Adds/removes trailing dots (e.g., "John Doe" ↔ "John Doe.")
  - **Diacritic Removal**: Replaces accented characters with base characters (e.g., "José" ↔ "Jose")
  - **Complex Combinations**: Handles multiple transformations together (e.g., "José García" ↔ "Garcia Jose.")
  - **Performance Optimized**: Pre-generates all variants for efficient matching

### Technical
- **Comprehensive Test Coverage**: Added extensive test suite covering all name matching scenarios
  - **Basic Variants**: Tests exact matches, case variations, and space handling
  - **Dot Handling**: Tests adding/removing dots with various name formats
  - **Diacritic Processing**: Tests Polish, Spanish, French, and other accented characters
  - **Word Order Switching**: Tests two-word name order switching with case variations
  - **Complex Combinations**: Tests multiple transformations applied together
  - **Edge Cases**: Tests empty names, single characters, very long names, and non-existent matches
  - **Performance Tests**: Ensures graceful handling of edge cases and large datasets
  - **Action Logging**: Verifies proper logging of variant matches for debugging
- **Algorithm Improvements**: Fixed variant generation to work bidirectionally (input names ↔ database names)
- **Code Cleanup**: Removed unused helper methods and optimized matching logic

## [v1.1.0] - 2025-01-16

### User Requests
- "Increate the limit 20 and load more when scrolled to the end" - Request to increase dancer history limit and add pagination

### Improved
- **Dancer History Pagination**: Enhanced dancer history screen with better pagination and load more functionality
  - **Increased Limit**: Changed from 6 to 20 events displayed initially
  - **Load More on Scroll**: Automatically loads more events when user scrolls near the bottom
  - **Smooth Pagination**: Seamless loading of additional history without page breaks
  - **Loading Indicators**: Shows loading spinner at bottom while fetching more data
  - **Better Performance**: Loads data in chunks to maintain smooth scrolling
  - **Complete History**: Users can now view full event history for dancers with many events

### Technical
- Updated DancerEventService.getRecentHistory to support configurable limit (default 20)
- Added DancerEventService.getMoreHistory method for pagination support
- Enhanced DancerHistoryScreen with scroll controller and pagination logic
- Added scroll listener to detect when user reaches bottom of list
- Implemented loading states for initial load and pagination
- Maintained existing functionality while improving data access

## [v1.0.9] - 2025-01-16

### User Requests
- "Nope, the problem is that after I clear the field and tap save the change does not get saved" - Request to fix notes field not saving when cleared

### Fixed
- **Notes Field Clearing Bug**: Fixed issue where clearing dancer notes field and saving would not actually clear the notes
  - **Proper Null Handling**: Fixed updateDancer method to properly handle null notes values
  - **Clear Field Support**: Users can now successfully clear dancer notes by emptying the field and saving
  - **Consistent Behavior**: Notes field now properly saves both content and empty state
  - **Database Update**: Fixed Value wrapper logic to always use provided notes value instead of falling back to existing value

### Technical
- Fixed DancerCrudService.updateDancer method to use `Value(notes)` instead of `Value(notes ?? dancer.notes)`
- Ensured null notes are properly saved to database when field is cleared
- Maintained existing functionality for non-null notes values

## [v1.0.8] - 2025-01-16

### User Requests
- "Event screen rows are covered by system bar. Please review all screens to void this." - Request to fix system bar coverage issues across all screens

### Fixed
- **System Bar Coverage Issues**: Fixed content being covered by system bars (status bar and navigation bar) across all screens
  - **Proper System UI Handling**: Added SystemChrome configuration for edge-to-edge display
  - **SafeArea Implementation**: Wrapped all main content areas with SafeArea to prevent system bar overlap
  - **Consistent Experience**: All screens now properly respect system UI areas
  - **Better UX**: Content is no longer hidden behind status bar or navigation bar

### Technical
- Added SystemChrome configuration in main.dart for transparent system bars and edge-to-edge mode
- Added MediaQuery builder in MaterialApp to ensure proper padding handling
- Wrapped content areas with SafeArea in:
  - Event screen tabs (Present, Planning, Summary)
  - Dancers screen
  - All list views and scroll views
- Maintained existing functionality while improving system UI integration

## [v1.0.7] - 2025-01-16

### User Requests
- "show a year too on that history screen records" - Request to add year to date display in dancer history

### Improved
- **Dancer History Date Display**: Added year to date format in dancer history screen
  - **Better Context**: Dates now show as "Jan 15, 2024" instead of just "Jan 15"
  - **Clearer Timeline**: Users can better understand when events occurred across different years
  - **Improved Readability**: Full date format makes it easier to distinguish events from different years

### Technical
- Updated DateFormat in DancerHistoryScreen from 'MMM dd' to 'MMM dd, yyyy'
- Maintained existing layout and styling while improving date information

## [v1.0.6] - 2025-01-16

### User Requests
- "Add dancer history to dancer context actions in dancer screen so I can try recall where I know them from" - Request to add history access to dancer context menu

### Added
- **Dancer History in Context Menu**: Added "View History" option to dancer context menu in dancers screen
  - **Quick Access**: Users can now view dancer's event history directly from the dancers list
  - **Memory Aid**: Helps users recall where they know dancers from by showing past events
  - **Consistent UX**: Uses the same DancerHistoryScreen as other parts of the app
  - **Proper Navigation**: Opens history screen with dancer's name and ID for context

### Technical
- Added DancerHistoryScreen import to DancerCardWithTags widget
- Added "View History" ListTile to dancer context menu with history icon
- Added proper action logging for history context menu interactions

## [v1.0.5] - 2025-01-16

### User Requests
- "I have this events file. I imported it in Android App but Alicja is missing the impression." - Request to fix impression import for non-served status dancers

### Fixed
- **Event Import Impression Bug**: Fixed missing impressions for dancers with 'present' or 'left' status during event import
  - **Extended Impression Support**: Impressions are now saved for all attendance statuses (present, served, left)
  - **Consistent Data Import**: All impression data from JSON files is now properly imported regardless of status
  - **Better Data Preservation**: No impression data is lost during import process
  - **Fixed Alicja's Impression**: Dancers like Alicja with 'present' status and impressions now have their data preserved

### Technical
- Updated EventImportService to save impressions for 'present' and 'left' status dancers using updateDanceImpression method
- Maintained existing behavior for 'served' status dancers using recordDance method
- Added proper impression handling for all attendance statuses during import process

## [v1.0.4] - 2025-01-16

### User Requests
- "Remove Version info row" - Request to remove version information from settings screen
- "The default data gets inserted after reset no matter if I select the checkbox" - Request to clarify reset behavior and UI text
- "Bump andriod app version along the changelog version" - Request to update Android app version to match changelog

### Removed
- **Version Info Row**: Removed version information display from General Settings tab
  - **Cleaner UI**: Removed "Version: 0.65.2" row from App Information section
  - **Simplified Display**: App Information now shows only App Name and Built for information
  - **Reduced Clutter**: Settings screen is now more focused on functional options

### Improved
- **Database Reset Dialog**: Clarified UI text to distinguish between essential defaults and test data
  - **Clearer Language**: Changed "Default ranks, tags, and scores" to "Essential system defaults (ranks, tags, scores)"
  - **Explanation Added**: Added note that essential defaults are required for app functionality and cannot be disabled
  - **Better Success Messages**: Updated success messages to use "essential defaults" terminology
  - **Reduced Confusion**: Users now understand that essential system data is always restored regardless of checkbox

### Changed
- **Select Dancers Screen**: Removed automatic default rank assignment when adding dancers to events
  - **No Auto-Ranking**: Dancers are now added to events without any rank assignment
  - **Manual Ranking**: Users must manually assign ranks later if desired
  - **Cleaner Workflow**: Simplifies the process of adding dancers to events
  - **Better UX**: Users have full control over when and how to rank dancers
  - **Updated Success Message**: Changed from "Added X dancers to event ranking" to "Added X dancers to event (no rank assigned)"

### Changed
- **Select Dancers Screen**: Removed automatic default rank assignment when adding dancers to events
  - **No Auto-Ranking**: Dancers are now added to events without any rank assignment
  - **Manual Ranking**: Users must manually assign ranks later if desired
  - **Cleaner Workflow**: Simplifies the process of adding dancers to events
  - **Better UX**: Users have full control over when and how to rank dancers
  - **Updated Success Message**: Changed from "Added X dancers to event ranking" to "Added X dancers to event (no rank assigned)"

### Fixed
- **Database Reset Dialog**: Fixed reset confirmation dialog that stopped working
  - **StatefulBuilder Issue**: Fixed variable scope issue in StatefulBuilder implementation
  - **Dialog Return Type**: Changed dialog return type to properly handle both confirmation and test data choice
  - **Proper State Management**: Fixed checkbox state management within the dialog
  - **Reliable Reset**: Reset functionality now works correctly with optional test data

### Technical
- Updated `_showResetConfirmationDialog` to use `Map<String, dynamic>` return type
- Fixed StatefulBuilder variable scope by moving `includeTestData` inside the builder
- Updated `_addSelectedDancers` method to use `AttendanceService.markPresent()` instead of `RankingService.setRanking()`
- Added `AttendanceService` import to `SelectDancersScreen`
- Updated pubspec.yaml version from 1.0.0+1 to 1.0.3+3 to match changelog version

### Fixed
- **Database Reset Dialog**: Fixed reset confirmation dialog that stopped working
  - **StatefulBuilder Issue**: Fixed variable scope issue in StatefulBuilder implementation
  - **Dialog Return Type**: Changed dialog return type to properly handle both confirmation and test data choice
  - **Proper State Management**: Fixed checkbox state management within the dialog
  - **Reliable Reset**: Reset functionality now works correctly with optional test data

### Technical
- Updated `_showResetConfirmationDialog` to use `Map<String, dynamic>` return type
- Fixed StatefulBuilder variable scope by moving `includeTestData` inside the builder
- Improved dialog result handling to properly extract both confirmation and test data choice
- Maintained all existing functionality while fixing the state management issue

## [v1.0.0] - 2025-01-16

### User Requests
- "make test data optional in reset action" - Request to make test data optional when resetting database

### Added
- **Optional Test Data in Reset**: Database reset now allows users to choose whether to include test data
  - **User Choice**: Checkbox in reset confirmation dialog to include/exclude test data
  - **Flexible Reset**: Users can reset to clean state or include sample data for testing
  - **Clear Feedback**: Different success messages based on whether test data was included
  - **Better UX**: More control over what gets restored after reset

### Improved
- **Import Validation Test**: Updated test to use actual EventImportParser service instead of direct JSON parsing
  - **Service Integration**: Test now uses the same parser service used by the app
  - **Better Validation**: Leverages the app's actual validation logic and error handling
  - **Consistent Behavior**: Test results now match what users would see in the app
  - **Proper Error Reporting**: Uses the service's structured error reporting format
  - **Real-World Testing**: Tests against actual historical data files with 100% success rate

### Technical
- Updated `AppDatabase.resetDatabase()` to accept optional `includeTestData` parameter
- Enhanced reset confirmation dialog with StatefulBuilder and checkbox for test data option
- Updated test/import_validation_test.dart to use EventImportParser.parseJsonContent()
- Removed direct JSON parsing in favor of service-based validation
- Maintained all existing test coverage while improving accuracy
- Test now validates 5 historical files with 94 events and 1066 unique dancers

## [v0.99.0] - 2025-01-16

### User Requests
- "Nice but this test should use service" - Request to update import validation test to use actual service

### Improved
- **Import Validation Test**: Updated test to use actual EventImportParser service instead of direct JSON parsing
  - **Service Integration**: Test now uses the same parser service used by the app
  - **Better Validation**: Leverages the app's actual validation logic and error handling
  - **Consistent Behavior**: Test results now match what users would see in the app
  - **Proper Error Reporting**: Uses the service's structured error reporting format
  - **Real-World Testing**: Tests against actual historical data files with 100% success rate

### Technical
- Updated test/import_validation_test.dart to use EventImportParser.parseJsonContent()
- Removed direct JSON parsing in favor of service-based validation
- Maintained all existing test coverage while improving accuracy
- Test now validates 5 historical files with 94 events and 1066 unique dancers

## [v0.98.0] - 2025-01-16

### User Requests
- "still some error" - Request to fix JSON parsing errors for historical event files

### Fixed
- **JSON Parsing Errors**: Fixed "type 'Null' is not a subtype of type 'String'" errors for historical event files
  - **Null Value Handling**: Updated ImportableEvent and ImportableAttendance models to handle null values gracefully
  - **Clear Error Messages**: Now provides specific error messages like "Event name is required and cannot be null or empty"
  - **Better Validation**: Checks for null, empty, or missing required fields with descriptive error messages
  - **Robust Parsing**: Prevents crashes when JSON files have incomplete data

### Added
- **Event Name Fix Script**: Created `scripts/fix_event_names.py` to automatically fix JSON files with missing event names
  - **Automatic Name Generation**: Adds default names like "Event on January 15, 2024" for events missing names
  - **Batch Processing**: Can fix multiple files or overwrite existing files
  - **Safe Operation**: Preserves all other data while only fixing missing names
  - **Date-Based Naming**: Generates readable names based on event dates
  - **Documentation**: Includes README with usage examples and requirements

### Technical
- Updated ImportableEvent.fromJson to handle null name and date fields
- Updated ImportableAttendance.fromJson to handle null dancer_name and status fields
- Added comprehensive null checking with descriptive FormatException messages
- Created Python script for batch fixing of JSON files
- Maintained all existing functionality while improving error handling

## [v0.97.0] - 2025-01-16

### User Requests
- "I still get Error: Provider<DancerTagService> not found for SelectDancersScreen when I open 'Select dancers' on android app" - Request to fix provider error

### Fixed
- **SelectDancersScreen Provider Error**: Fixed "Provider<DancerTagService> not found" error on Android
  - **Provider Context Issue**: SelectDancersScreen was being navigated to without proper provider context
  - **MultiProvider Wrapper**: Added MultiProvider wrapper when navigating to SelectDancersScreen
  - **Service Dependencies**: Re-provided all necessary services (DancerService, DancerCrudService, DancerTagService, RankingService)
  - **Android Compatibility**: Fixed provider access issues specific to Android platform
  - **Tag Filtering**: Tag filtering functionality now works correctly on Android

### Technical
- Added MultiProvider wrapper in PlanningTabActions.onFabPressed method
- Added missing imports for database and service classes
- Maintained all existing functionality while fixing provider context issues

## [v0.96.0] - 2025-01-16

### User Requests
- "Do these now" - Request to implement small improvements from todo list

### Fixed
- **Summary Tab Past Event Actions**: Fixed "mark absent" and "mark as left" actions showing for past events
  - **Contextual Actions**: These actions are now hidden for past events where they don't make sense
  - **Better UX**: Prevents confusion by hiding irrelevant actions for past events
  - **Event Status Aware**: Dialog now checks if event is past using EventStatusHelper
  - **Maintained Functionality**: All other actions remain available for past events

- **Select Dancers AppBar Subtitle**: Fixed subtitle alignment not being centered
  - **Proper Centering**: Changed crossAxisAlignment from start to center
  - **Better Visual Balance**: Event name subtitle now appears centered under "Select Dancers"
  - **Consistent Design**: Matches the centered alignment pattern used in other screens

### Technical
- Updated DancerActionsDialog to hide presence toggle and mark as left actions for past events
- Fixed AppBar title Column alignment in SelectDancersScreen
- Maintained all existing functionality while improving contextual behavior

## [v0.95.0] - 2025-01-16

### User Requests
- "I got an error on Select Dancers screen" - Request to fix Select Dancers screen error
- "Run the app and observe the logs" - Request to investigate and fix app errors

### Fixed
- **Select Dancers Screen Provider Error**: Fixed "could not find correct provider<DancerTagService>" error
  - **Missing Provider**: Added DancerTagService and DancerCrudService to main.dart providers
  - **Proper Dependencies**: Configured ProxyProvider2 to correctly inject DancerCrudService into DancerTagService
  - **Tag Filtering**: Select Dancers screen now properly supports tag filtering functionality
  - **Service Integration**: All tag-related features now work correctly in the Select Dancers screen

- **Fluttertoast macOS Error**: Fixed MissingPluginException for fluttertoast on macOS
  - **Platform Detection**: Updated ToastHelper to detect macOS platform
  - **SnackBar Fallback**: Uses SnackBar instead of fluttertoast on macOS for better compatibility
  - **Native Android Toasts**: Maintains native Android toasts on Android platform
  - **Cross-Platform Support**: Toast notifications now work correctly on all supported platforms

### Technical
- Added DancerCrudService and DancerTagService imports to main.dart
- Added ProxyProvider for DancerCrudService in main.dart
- Added ProxyProvider2 for DancerTagService with proper dependency injection
- Updated ToastHelper._showToast method to use platform-specific toast implementations
- Maintained all existing functionality while fixing provider and platform compatibility issues

## [v0.94.0] - 2025-01-16

### User Requests
- "add existing dancer screen obscured by system bar on Android" - Request to fix system bar coverage
- "tag filtering does not work for 'Cuban DC Festival'" - Request to fix tag filtering functionality

### Fixed
- **Add Existing Dancer Screen System Bar**: Fixed screen being obscured by Android system navigation bar
  - **SafeArea Wrapper**: Added SafeArea widget to properly handle system UI padding
  - **Better UX**: Screen content is now fully visible and accessible on Android
  - **Consistent Behavior**: Matches other screens in the app for system UI handling

- **Tag Filtering Reactivity**: Improved tag filtering to properly update when data changes
  - **Better Stream Watching**: Enhanced watchAvailableDancersForEventByTag method
  - **Improved Reactivity**: Tag filtering now properly responds to changes in rankings and attendances
  - **More Reliable**: Fixed potential issues with tag filtering not updating correctly

### Technical
- Added SafeArea wrapper to AddExistingDancerScreen body
- Improved DancerTagService.watchAvailableDancersForEventByTag method for better reactivity
- Maintained all existing functionality while fixing system UI and filtering issues

## [v0.93.0] - 2025-01-16

### User Requests
- "Android - the FAB button is covered with bottom system bar" - Request to fix FAB positioning on Android
- "extract this repeated code into single place" - Request to refactor repeated FAB padding code

### Fixed
- **Android FAB Positioning**: Fixed FAB buttons being covered by Android system navigation bar
  - **System UI Aware**: FABs now automatically account for Android system navigation bar padding
  - **Consistent Positioning**: All FABs across the app now have proper bottom spacing
  - **Cross-Platform**: Works correctly on both Android and other platforms
  - **Better UX**: FABs are no longer hidden behind system UI elements

### Improved
- **Code Reusability**: Extracted repeated FAB padding code into reusable `SafeFAB` widget
  - **Single Source of Truth**: All FABs now use the centralized `SafeFAB` widget
  - **Consistent Behavior**: Automatic system UI padding handling across all screens
  - **Easier Maintenance**: Future FAB positioning changes only need to be made in one place
  - **Type Safety**: Proper parameter handling for both regular and extended FABs

### Technical
- Created new `SafeFAB` widget in `lib/widgets/safe_fab.dart`
- Updated all screens to use `SafeFAB` instead of manual padding:
  - `EventScreen`, `DancersScreen`, `HomeScreen`
  - `SelectDancersScreen`, `TagsManagementTab`
  - `ScoresManagementTab`, `RanksManagementTab`
- Restructured settings tabs to use Scaffold's `floatingActionButton` instead of Stack with Positioned widgets
- Maintained all existing functionality while improving code organization

## [v0.92.0] - 2025-01-16

### User Requests
- "edit ranking action does not make sense for past events" - Request to hide ranking actions for past events
- "score group header - move counter as simple text in parenthesis instead of pill" - Request to simplify score group counter display

### Changed
- **Past Event Ranking Actions**: Ranking actions are now hidden for past events
  - **Contextual Actions**: Edit/Set Ranking options only appear for current and future events
  - **Better UX**: Prevents confusion by hiding irrelevant actions for past events
  - **Event Status Aware**: Dialog now loads event data to determine if event is past
  - **Summary Tab Aware**: Ranking actions also hidden on summary tab for consistency
  - **Maintained Functionality**: All other actions remain available for past events

- **Score Group Headers**: Changed counter display from pill to simple text in parentheses
  - **Cleaner Design**: Removed pill container and styling for simpler appearance
  - **Better Readability**: Counter now appears as "(X)" next to score name
  - **Consistent Styling**: Uses onSurfaceVariant color for subtle appearance
  - **Space Efficient**: Takes up less visual space while maintaining clarity

### Technical
- Converted `DancerActionsDialog` from StatelessWidget to StatefulWidget to load event data
- Added event loading logic to check if event is past using `EventStatusHelper.isPastEvent()`
- Added conditional rendering for ranking actions based on event status
- Updated score group header in summary tab to use simple text instead of pill container
- Maintained all existing functionality while improving contextual behavior

## [v0.9.2] - 2025-07-04

### User Requests
- "nice, commit" - User requested to commit the CLI navigation improvements

### Added
- Enhanced CLI navigation with tab and action support
- Support for `/event/current/present-tab/add-existing-dancer` navigation path
- Tab name mapping from CLI format to internal format (e.g., "present-tab" → "present")
- Direct action triggering in PresentTab for add existing dancer dialog
- Initial tab and action parameters for EventScreen and PresentTab

### Technical
- Updated CliArguments to include initialTab and initialAction parameters
- Modified CliNavigator to extract values in constructor and pass to EventScreen
- Enhanced EventScreen to accept and handle initial tab and action parameters
- Updated PresentTab to accept initialAction and directly show add existing dancer dialog
- Added tab name mapping logic in CLI navigation parsing
- Updated help documentation with new navigation path examples

## [v0.9.1] - 2025-07-04

### User Requests
- "you forgot the target" - User pointed out missing macOS target specification
- "you forgot the macOS target" - User reminded about macOS target requirement

### Added
- AppBar color customization via dart-define parameter
- Support for `--dart-define=APPBAR_COLOR=#FF0000` to customize AppBar color
- Color parsing utility in AppTheme for hex color strings

### Technical
- Added `_parseAppBarColorFromDefine()` function in main.dart
- Enhanced AppTheme with `parseColor()` method for hex color parsing
- Updated DancerRankingApp to accept and apply custom appBarColor
- Added proper error handling for invalid color values

## [v0.9.0] - 2025-07-04

### User Requests
- "Nope, extract the needed values in constructor" - User requested to extract CLI argument values in constructor instead of passing the entire object

### Changed
- Refactored CliNavigator to extract needed values in constructor
- Removed dependency on CliArguments object within CliNavigator widget
- Simplified widget properties to focus on specific navigation parameters

### Technical
- Updated CliNavigator constructor to extract navigationPath, eventIndex, and autoTapAdd
- Removed const keyword from CliNavigator constructor due to non-const parameters
- Updated all references to use extracted properties instead of cliArgs object

## [v0.8.5] - 2025-07-04

### User Requests
- "nice, let's try out the going to current event" - User wanted to test current event navigation
- "you forgot the target" - User pointed out missing target specification

### Added
- CLI navigation support for current event detection
- Support for `--dart-define=NAV_PATH=/event/current` to navigate to today's event
- Automatic fallback to home screen when no current event is found
- Detailed logging of available events when current event is not found

### Technical
- Enhanced `_findCurrentEvent()` method to compare dates properly
- Added comprehensive logging for debugging navigation issues
- Updated help documentation with current event examples
- Improved error handling for invalid navigation paths

## [v0.8.4] - 2025-07-04

### User Requests
- "nice, commit" - User requested to commit the CLI navigation feature

### Added
- CLI navigation system for automated testing and development
- Support for `--dart-define=NAV_PATH=<path>` to navigate directly to specific screens
- Support for `--dart-define=EVENT_INDEX=<index>` for legacy event navigation
- Support for `--dart-define=AUTO_TAP_ADD=true` to automatically trigger add actions
- Support for `--dart-define=HELP=true` to show CLI help information

### Technical
- Created CliArguments class to parse and store CLI parameters
- Implemented CliNavigator widget for automatic navigation handling
- Added parseCliArguments() function to handle dart-define parameters
- Created showCliHelp() function with comprehensive usage examples
- Updated main.dart to use CliNavigator when CLI arguments are provided
- Added navigation path parsing with support for /event/<index> paths
- Implemented automatic event resolution and error handling

## [v0.8.3] - 2025-07-04

### User Requests
- "commit" - User requested to commit the tag filtering improvements

### Added
- Tag filtering support in Add Dancer Dialog
- Simplified tag filter chips with pill format
- Auto-apply filtering when tags are selected
- Clear visual feedback for active tag filters

### Technical
- Enhanced AddDancerDialog with tag filtering capabilities
- Implemented SimplifiedTagFilter widget for better UX
- Added tag selection state management
- Updated dancer filtering logic to include tag-based filtering
- Improved performance with optimized filter queries

## [v0.8.2] - 2025-07-04

### User Requests
- "commit" - User requested to commit the dancer filtering improvements

### Added
- Simplified dancer filtering with pill format
- Auto-apply filtering when tags are selected
- Clear visual feedback for active filters
- Improved filter performance and user experience

### Technical
- Refactored tag filtering to use pill format
- Implemented auto-apply filtering logic
- Enhanced filter state management
- Updated UI components for better visual feedback
- Optimized filter queries for better performance

## [v0.8.1] - 2025-07-04

### User Requests
- "commit" - User requested to commit the future events tab behavior

### Changed
- Future events (1+ days ahead) now show only Planning tab
- Past events show Present and Summary tabs only
- Current events (today) show all three tabs: Planning, Present, Summary
- Old events (2+ days ago) show only Summary tab

### Technical
- Updated EventStatusHelper to properly categorize event dates
- Modified EventScreen to show appropriate tabs based on event age
- Enhanced tab indicator text to reflect available tabs
- Improved user experience for different event types

## [v0.8.0] - 2025-07-04

### User Requests
- "commit" - User requested to commit the initial implementation

### Added
- Initial implementation of Dancer Ranking App
- Basic event management functionality
- Dancer tracking and ranking system
- Attendance and scoring features
- Import/export capabilities

### Technical
- Flutter-based cross-platform application
- SQLite database with Drift ORM
- Material Design 3 UI components
- Provider pattern for state management
- Comprehensive logging and error handling