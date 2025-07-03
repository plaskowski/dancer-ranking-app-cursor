# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v0.92.0] - 2025-01-16

### User Requests
- "edit ranking action does not make sense for past events" - Request to hide ranking actions for past events
- "score group header - move counter as simple text in parenthesis instead of pill" - Request to simplify score group counter display

### Changed
- **Past Event Ranking Actions**: Ranking actions are now hidden for past events
  - **Contextual Actions**: Edit/Set Ranking options only appear for current and future events
  - **Better UX**: Prevents confusion by hiding irrelevant actions for past events
  - **Event Status Aware**: Dialog now loads event data to determine if event is past
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

## [v0.91.0] - 2025-07-03

### User Requests
- "do the import preview right away after selecting a file (or dropping to drop zone)" - Request to automatically show import preview after file selection
- "use native android toasts" - Request to replace Flutter SnackBars with native Android toasts

### Added
- **Automatic Preview**: Import preview now appears immediately after file selection or drop
  - **Seamless Workflow**: No more manual "Next" button needed after file selection
  - **Instant Feedback**: Users see preview data as soon as files are selected
  - **Loading Indicator**: File selection step shows loading spinner while parsing files
  - **Automatic Advancement**: Valid files automatically advance to preview step
- **Native Android Toasts**: Replaced Flutter SnackBars with native Android toast notifications
  - **Platform Native**: Uses Android's native toast system for better integration
  - **Consistent Styling**: Maintains app's color scheme and theming
  - **Better Performance**: Native toasts are more efficient than Flutter SnackBars
  - **Cross-Platform Support**: Works on Android with fallback for other platforms

### Changed
- **Import Workflow**: Streamlined import process by eliminating manual preview step
  - **Simplified Steps**: File selection step now automatically processes and shows preview
  - **Better UX**: Reduced number of clicks needed to complete import process
  - **Immediate Feedback**: Users get instant validation and preview of their files
- **Toast System**: Replaced SnackBar-based toasts with native Android toasts
  - **Native Integration**: Better integration with Android system
  - **Improved UX**: More familiar toast behavior for Android users
  - **Consistent Theming**: Maintains app's color scheme across all toast types

### Technical
- Modified `_onFilesSelected` method to automatically trigger file parsing
- Updated `_parseFiles` method to automatically advance to preview step for valid files
- Removed manual "Next" button from file selection step
- Added loading indicator to file selection step during parsing
- Added `fluttertoast` dependency for native Android toast support
- Updated `ToastHelper` to use native Android toasts with platform detection
- Maintained all existing functionality while improving user experience

## [v0.90.0] - 2025-01-16

### User Requests
- "import many files at once" - Request to add support for importing multiple event files simultaneously

### Added
- **Multiple File Import**: Added support for importing multiple event files at once
  - **Multi-File Selection**: Users can now select multiple JSON files in a single import session
  - **Drag & Drop Support**: Multiple files can be dropped simultaneously
  - **Combined Preview**: All files are parsed and shown in a unified preview
  - **Bulk Import**: All valid events from all files are imported in a single operation
  - **Error Handling**: Individual file errors are shown while valid files proceed
  - **Progress Tracking**: Import progress shows combined operation across all files

### Improved
- **File Selection UI**: Updated file selection step to show multiple selected files
  - **File List Display**: Shows count and details of all selected files
  - **Individual File Info**: Each file shows name and size
  - **Clear All Option**: Easy way to clear all selected files at once
  - **Updated Help Text**: Clarified that multiple files are supported

### Technical
- Enhanced `EventFileSelectionStep` to support multiple file selection
- Updated `ImportEventsDialog` to handle multiple parse results
- Added combined preview logic to merge results from multiple files
- Modified import logic to combine events from all files into single JSON structure
- Maintained backward compatibility with single file imports
- Added proper error handling for individual file failures

## [v0.89.0] - 2025-01-16

### User Requests
- "The filter fields on dancers screen do not scroll with the dancers list" - Request to fix scrolling behavior
- "Why the search field looses focus after every key press?" - Request to fix search field focus issue
- "Make search more inteligent, it should only match a start of word in the dancer name" - Request to improve search precision

### Fixed
- **Unified Scrolling**: Fixed filter fields and dancers list to scroll together as one unit
  - **Single Scroll Area**: Replaced separate scrollable areas with unified `CustomScrollView`
  - **Sliver Components**: Used `SliverToBoxAdapter` for filters and `SliverList` for dancers
  - **Natural Scrolling**: Filter fields now scroll away smoothly with the rest of content
  - **Better UX**: Consistent scrolling behavior like other screens in the app

- **Search Field Focus**: Fixed search field losing focus after every keystroke
  - **Stable Filter Section**: Moved `StreamBuilder` to only wrap dancers list, not entire body
  - **Preserved Focus**: Search field maintains focus while typing
  - **Smooth Typing**: No more focus loss after each keystroke
  - **Better Performance**: Only necessary parts rebuild when data changes

### Improved
- **Intelligent Word-Start Search**: Enhanced search to only match start of words
  - **Word Boundary Matching**: Split names and notes into words, match query against word starts
  - **More Precise**: Only matches meaningful word beginnings, not substrings anywhere
  - **Intuitive Behavior**: Matches how users naturally think about names
  - **Professional Quality**: Similar to how most search engines work
  - **Case Insensitive**: Still ignores case for better usability

### Technical
- Restructured widget hierarchy to separate stable filter section from dynamic dancers list
- Enhanced `_filterDancers()` method with word-start matching logic
- Used `CustomScrollView` with slivers for unified scrolling experience
- Maintained all existing functionality while improving UX
- Improved search precision with `split(' ')` and `startsWith()` logic

## [v0.88.0] - 2025-01-16

### User Requests
- "dancers screen - add tag filter" - Request to add tag filtering functionality to dancers screen
- "add both filter fields into scrollview so they don't take space" - Request to make filter fields scrollable to save vertical space

### Added
- **Tag Filtering**: Added tag filter functionality to dancers screen
  - **Tag Filter Chips**: Users can now filter dancers by selecting specific tags
  - **Combined Filtering**: Search and tag filters work together for precise dancer filtering
  - **Clear Filter Option**: Easy way to clear tag selection with close button
  - **Visual Feedback**: Selected tags are highlighted with primary container color
  - **Smart Empty State**: Empty state messages now consider both search and tag filters

### Improved
- **Scrollable Filter Section**: Both search field and tag filter are now in a scrollable container
  - **Space Efficient**: Filter fields don't take up fixed vertical space
  - **Better UX**: Users can scroll through filters when needed, especially on smaller screens
  - **Flexible Layout**: Filter section adapts to content without blocking dancer list
  - **Consistent Design**: Maintains Material Design principles with proper spacing

### Technical
- Added `_selectedTagId` state variable to track selected tag filter
- Enhanced `_filterDancers()` method to handle both search and tag filtering
- Integrated `TagFilterChips` widget for consistent tag filtering UI
- Wrapped filter fields in `SingleChildScrollView` for space efficiency
- Updated empty state logic to consider both filter types
- Maintained existing search functionality while adding tag filtering

## [v0.87.0] - 2025-01-16

### User Requests
- "Event preview list should not be scrollable as it conflicts with overall scrolling of the screen" - Request to fix scrolling conflicts in events import preview

### Improved
- **Events Import Preview**: Fixed scrolling conflicts by making event preview list non-scrollable
  - **No More Scrolling Conflicts**: Removed fixed-height ListView that was conflicting with overall screen scrolling
  - **Better UX**: Users can now scroll through the entire preview naturally without nested scroll areas
  - **Cleaner Layout**: Event preview cards now flow naturally in the main scroll area
  - **Maintained Functionality**: All event details and expansion tiles still work as expected

### Technical
- Replaced `SizedBox(height: 300, child: ListView.builder)` with `Column` using `map()` spread operator
- Added margin to event cards for proper spacing
- Maintained all existing functionality including expansion tiles and attendance details
- Improved code readability with better formatting

## [v0.86.0] - 2025-01-16

### User Requests
- "remove the import completion toast as it obscures the summary view" - Request to remove toast notifications that block the import results view

### Improved
- **Events Import Summary View**: Removed toast notifications that were obscuring the import results
  - **Cleaner Summary**: Import completion toasts no longer block the detailed results view
  - **Better Visibility**: Users can now see all import statistics and details without toast interference
  - **Comprehensive Information**: Summary view already provides all necessary import result information
  - **Improved UX**: No more need to wait for toasts to disappear to read import results

### Technical
- Removed `ToastHelper.showSuccess` and `ToastHelper.showWarning` calls from `_performImport` method
- Added explanatory comment about why toasts were removed
- Maintained action logging for import completion tracking
- Summary view continues to show all import statistics and error details

## [v0.85.0] - 2025-01-16

### User Requests
- "add action to events import summary - 'Import more files'" - Request to add ability to import additional files after completing an import
- "future events (in 1+ days) should only have planning tab" - Request to simplify UI for distant future events

### Added
- **Import More Files Action**: Added "Import more files" button to events import summary screen
  - **Seamless Workflow**: Users can now import multiple event files without closing and reopening the dialog
  - **Reset Functionality**: Button resets the dialog to file selection step, clearing previous import data
  - **Action Logging**: Tracks when users choose to import additional files for analytics
  - **Better UX**: Eliminates need to close and reopen import dialog for multiple imports

### Changed
- **Event Screen Tab Logic**: Enhanced tab visibility based on event timing
  - **Far Future Events**: Events 1+ days in the future now show only the Planning tab
  - **Current Events**: Events today/within 1 day continue to show all 3 tabs (Planning, Present, Summary)
  - **Past Events**: Events before today show Present and Summary tabs
  - **Old Events**: Events 2+ days ago show only Summary tab
  - **Cleaner UI**: Distant future events focus users on planning tasks only
  - **Better UX**: Simplified interface for events that don't need immediate action

### Technical
- Enhanced `_buildStepControls` method in `ImportEventsDialog` to show "Import more files" button on results step
- Added `_resetToFileSelection` method to clear import state and return to step 0
- Added action logging to track user behavior when importing multiple files
- Maintained existing "Close" button functionality alongside new import action
- **EventStatusHelper Enhancement**: Added `isFarFutureEvent()` method to detect events 1+ days in the future
- **Centralized Logic**: Updated `getAvailableTabs()` method to handle all event timing scenarios
- **EventScreen Refactoring**: Updated all tab logic to use centralized `EventStatusHelper` methods
- **Dynamic Tab Names**: Improved logging to use actual available tab names instead of hardcoded values
- **Performance**: Single tab events no longer use PageView, improving performance

## [v0.84.0] - 2025-01-16

### User Requests
- "move info block into the scroll area to not take vertical space" (Add existing dancer dialog)
- "move 'already danced' checkbox in above the tags section so I don't have to scroll through tags for it" (Add new dancer dialog)

### Improved
- **Add Existing Dancer Dialog**: Info block is now inside the scrollable area, so it doesn't take up fixed vertical space
- **Add New Dancer Dialog**: "Already danced" checkbox (and impression field) now appear above the tags section, right after notes
- **Better Usability**: Both dialogs are more compact and user-friendly, especially on smaller screens

### Technical
- Refactored layout in `add_existing_dancer_screen.dart` to move info block into the scrollable list
- Refactored layout in `add_dancer_dialog.dart` to move "already danced" option above tags

## [v0.83.0] - 2025-01-16

### User Requests
- "Move import actions to general settings tab" - Request to relocate import functionality from home screen to settings
- "Great, remove import button from Dancers screen too" - Request to remove import functionality from dancers screen as well
- "merge settings section into data management" - Request to consolidate data-related settings into single section
- "the import actions say about CSV but we use JSON format" - Request to fix incorrect file format descriptions
- "The import sceens, at the last step have additional actions. They don't make much sense. Remove them." - Request to remove unnecessary action buttons from import completion screens

### Changed
- **Import Actions Location**: Moved import functionality from home screen overflow menu to general settings tab
  - **New Data Management Section**: Added dedicated "Data Management" section in general settings tab
  - **Import Dancers**: Moved from home screen, now accessible via settings with icon and descriptive text
  - **Import Events**: Moved from home screen, now accessible via settings with icon and descriptive text
  - **Cleaner Home Screen**: Removed overflow menu entirely since import events was the only action
  - **Better Organization**: Data import actions now logically grouped with other data management features
  - **Consistent Navigation**: Import actions now follow same pattern as other settings actions
- **Dancers Screen Cleanup**: Removed import button from dancers screen app bar
  - **Centralized Import**: All import functionality now consolidated in settings
  - **Cleaner Interface**: Simplified dancers screen by removing redundant import button
  - **Single Import Location**: Users now have one consistent place to find all import actions
- **Settings Organization**: Merged "Data Import" and "General Settings" sections into unified "Data Management"
  - **Logical Grouping**: All data-related operations (import dancers, import events, reset database) in one section
  - **Cleaner Layout**: Reduced number of cards in settings for better visual organization
  - **Consistent Terminology**: "Data Management" better describes the combined functionality
- **Import Completion Simplification**: Removed unnecessary action buttons from import completion screens
  - **Cleaner Completion**: Import dialogs now show results without confusing additional actions
  - **Simplified UX**: Users can simply close the dialog when import is complete
  - **Removed Actions**: Eliminated "View Dancers", "View Events", and "Import Another" buttons

### Improved
- **Action Logging**: Enhanced logging to track source location of import actions (settings vs home)
- **Error Handling**: Added proper context mounting checks for async operations to prevent build context warnings
- **UI Consistency**: Import actions now use consistent styling with other settings tiles
- **Navigation Simplicity**: Reduced UI complexity by consolidating import functionality

### Technical
- Enhanced `GeneralSettingsTab` with new data import section and action handlers
- Removed PopupMenuButton from `HomeAppBar` since it was empty after moving import events
- Removed import button and `_showImportDialog` method from `DancersScreen`
- Removed unused import statement for `import_dancers_dialog.dart` from dancers screen
- Added proper async/await patterns with context.mounted checks to prevent linter warnings
- Maintained existing import dialog functionality while changing access location
- Updated action logging to distinguish between settings and home screen sources

### Fixed
- **Import Descriptions**: Corrected import action subtitles to show "JSON file" instead of "CSV file"
  - **Accurate Information**: Import dancers and events descriptions now correctly indicate JSON format
  - **User Clarity**: Prevents confusion about expected file format for imports

## [v0.82.0] - 2025-01-16

### User Requests
- "Hmm, ok, but in such care let's have just one default rank - 'Not decided yet'" - Request to simplify default ranks
- "Let's minimize other default entries so it is less work to clean them up after reset" - Request to reduce all default data
- "As I plan the smart suggestions these example tags makes little sense" - Request to improve tag quality
- "option 2" - Choose contextual tags over no defaults
- "Nope, provide 3 related to where I can know them from" - Request location-based tags
- "These sounds too generic, use like 'Monday Class', 'Cuban DC Festiaval'" - Request specific examples

### Changed
- **Minimized All Default Data**: Dramatically reduced default entries across the system
  - **Default Ranks**: Reduced from 5 → 1 ("Not decided yet")
  - **Default Tags**: Reduced from 8 → 3 with specific contextual examples ("Monday Class", "Cuban DC Festival", "Friday Social")
  - **Default Scores**: Reduced from 5 → 3 ("Good", "Okay", "Poor")
  - **Cleaner Reset**: Much less cleanup work needed after database reset
  - **Smart Suggestions Ready**: Tags now demonstrate proper context for filtering and suggestions
  - **User Freedom**: Easier for users to start with clean slate and build their own system
  - **Practical Examples**: Tags show specific venues/events where dancers are known from

### Technical
- Modified `_insertDefaultRanks()` method to only insert one default rank
- Redesigned `_insertDefaultTags()` from 8 generic tags to 3 specific contextual examples
- Streamlined `_insertDefaultScores()` from 5 scores to 3 basic scores
- Contextual tags demonstrate proper tagging for smart suggestions and filtering
- Maintained backward compatibility with existing functionality
- Reduced database initialization overhead significantly

## [v0.81.0] - 2025-01-16

### User Requests
- "option to reset DB in settings screen (general tab)" - Request to add database reset functionality
- "Skip the defaults" - Request to modify reset to not restore default data
- "Let's commit and test it" - Request to implement and commit the feature
- "and update the specs" - Request to update specification documentation

### Added
- **Database Reset Option**: Added complete database reset functionality in General Settings tab
  - **Warning UI**: Red-colored action with clear warning styling and descriptive text
  - **Comprehensive Confirmation**: Detailed dialog listing all data that will be permanently deleted
  - **Complete Data Wipe**: Resets all tables (events, dancers, rankings, attendances, tags, scores)
  - **No Default Restoration**: Database remains completely empty after reset (no default data re-inserted)
  - **Loading State**: Progress indicator during reset operation
  - **User Feedback**: Success/error notifications via toast messages

### Technical
- **Database Method**: Added `resetDatabase()` method to `AppDatabase` class for complete data clearing
- **Settings Integration**: Enhanced `GeneralSettingsTab` with reset option and confirmation workflow
- **Error Handling**: Proper try-catch with loading states and user-friendly error messages
- **Provider Integration**: Uses existing database provider for consistent data access
- **Transaction Safety**: Reset operation wrapped in database transaction for data integrity

### Changed
- **General Settings Tab**: Replaced placeholder content with functional database reset option
- **Settings Documentation**: Updated Product specification with complete reset functionality details

## [v0.80.0] - 2024-12-27

### User Requests
- "Looks great, let's implement it" - implement the Dancer History screen

### Added
- **Dancer History Screen**: Added new screen to view recent dance history for any dancer
- **History Navigation**: Added "View History" action to dancer actions dialog 
- **Recent History Service**: Added `getRecentHistory` method to `DancerEventService`
- **History Data Model**: Added `DancerRecentHistory` model for displaying event history

### Technical
- Created `DancerHistoryScreen` with minimal UI design showing last 6 events
- Added database query to fetch events where dancer attended (INNER JOIN on attendances)
- Integrated navigation from Event Planning Tab → Dancer Actions → "View History"
- Screen displays: event date/name, danced status (☑/☐), scores, and impressions
- Uses checkbox characters to distinguish between danced vs present-only events
- Shows assessment scores for present-only events to explain why no dance occurred

## [v0.71.0] - 2025-01-16

### User Requests
- "Let's write a design for this (no code yet)" - Request to design new Dancer History screen
- "Too complex, stay with 'Ranking Context: When ranking dancers at events, users need to recall past performance and interactions' only" - Simplify design scope
- "What is this '🏆 Advanced'?" - Question about ranking system terminology
- "Nah, I don't need the rank in this history and it is used only for planning the event. In history only the actual score and impression matter." - Remove rankings from history
- "What is this '❌ Absent'?" - Question about absent status in history
- "the 'Left early' is of no use" - Remove left early status from history
- "Great commit the spec for now" - Request to commit the design specification

### Added
- **Dancer History Screen Design**: Created comprehensive design specification for new dancer history feature
  - **Purpose**: Help users recall past dance experiences and interactions when making ranking decisions during event planning
  - **Simple UI**: Single screen showing recent attended events with dance scores and impressions
  - **Focus on Relevance**: Shows only events where dancer actually attended (no absent/non-events)
  - **Essential Data**: Date, event name, dance status (danced vs present only), scores, and impressions
  - **Navigation**: Accessed from Event Planning Tab → Dancer → "View History"

### Designed
- **Clean Data Model**: Simple `DancerRecentHistory` class with essential fields only
- **Efficient Query**: Shows last 6 events where dancer attended (INNER JOIN on attendances)
- **User-Focused Information**: Recent dance scores, impressions, and attendance patterns
- **Simplified Status**: Only "Danced" vs "Present only" - removed rankings, absent, and left early as irrelevant
- **Context-Driven**: Designed specifically for ranking decision support during event planning

### Simplified
- **Minimal UI Design**: Further simplified interface based on user feedback
  - **Removed Header Stats**: Eliminated summary section with total dances and recent scores
  - **Compact Event List**: One line per event showing "Date - Event • ☑/☐ Score • Notes"
  - **Checkbox Icons**: Used ☑ (danced) and ☐ (present only) to save space for longer impressions
  - **Assessment Scores**: Show scores for present-only events to indicate why no dance occurred
  - **No Visual Clutter**: Removed separators and extra formatting elements
  - **Essential Only**: Shows just the core information needed for ranking decisions

### Technical
- Design specification saved at `specs/designs/design_DancerHistory.md`
- Database query design using existing tables (events, attendances, scores)
- Service method planned for existing `DancerEventService`
- Single screen file approach for simplicity
- Focus on actual dance experiences rather than planning preferences

## [v0.71.0] - 2025-01-08

### User Requests
- "do this" - Complete events import help text and example file improvements

### Added
- **Events Import Example File**: Created comprehensive `example_events_import.json` showing proper JSON format
  - **Complete Examples**: Demonstrates all attendance types (present, served, left)
  - **Multiple Events**: Shows different event types with varied attendance records
  - **Full Feature Coverage**: Examples include impressions, scores, and different status combinations
  - **Clean JSON Format**: Valid JSON without comments for direct use as template

### Improved  
- **Events Import Help Text**: Completely redesigned help dialog with comprehensive guidance
  - **Structured Information**: Organized into clear sections (JSON Structure, Attendance Fields, Status Meanings, etc.)
  - **Detailed Field Explanations**: Complete description of all required and optional fields
  - **Status Clarification**: Clear explanations of "present", "served", and "left" status meanings
  - **Automatic Features**: Detailed explanation of auto-creation behavior for dancers and scores
  - **Best Practices**: Tips for successful imports including character limits and naming conventions
  - **Example Reference**: Points users to example file for practical guidance
  - **Scrollable Content**: SingleChildScrollView for better dialog usability with extensive help content

### Enhanced
- **User Experience**: Import process now provides comprehensive guidance before users attempt import
- **Error Prevention**: Detailed help reduces likelihood of malformed JSON files
- **Self-Service Support**: Users have complete reference material without needing external documentation

### Technical
- Updated `ImportEventsDialog._showHelpDialog()` with comprehensive help content
- Applied proper Dart formatting to maintain code quality standards
- Maintained existing dialog functionality while expanding help content