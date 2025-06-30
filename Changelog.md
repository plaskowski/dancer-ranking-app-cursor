# Changelog

All notable changes to the Dancer Ranking App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [v0.47.0] - 2025-01-12

### User Requests
- "Let's implement the service part" - referring to Event Import feature service layer implementation

### Added
- **Event Import Service Layer**: Complete backend infrastructure for bulk importing historical event data from JSON files
  - JSON format support for events with attendance records and dancer statuses
  - Three attendance statuses: `present` (was there), `served` (danced with), `left` (left before dance)
  - Optional impression/notes for served status with post-dance feedback
  - Automatic missing dancer creation during import process
  - Duplicate event detection and skip functionality
  - Complete transaction safety with automatic rollback on errors

### Technical
- **EventImportParser**: Handles JSON parsing, structure validation, and data extraction with comprehensive error reporting
- **EventImportValidator**: Validates import data against business rules and database constraints with conflict detection
- **EventImportService**: Main orchestrator for complete import workflow with atomic database transactions
- **Extended Import Models**: Complete data model set for event import operations (ImportableEvent, ImportableAttendance, etc.)

### Architecture
- **Service Integration**: Seamlessly integrates with existing EventService, DancerService, and AttendanceService
- **Comprehensive Logging**: Action logging throughout all import operations following established patterns
- **Validation Options**: Support for validation-only mode, duplicate handling, and missing dancer creation preferences
- **Error Handling**: Graceful error handling with detailed user-friendly messages and import summaries
- **Performance Optimized**: Batch operations, pre-fetching, and efficient database queries for large imports

### JSON Format Support
- **Event Structure**: Events with name, date (YYYY-MM-DD), and attendances array
- **Attendance Records**: Dancer name, status, and optional impression fields
- **Metadata Support**: Optional metadata section for import tracking and source information
- **Validation Rules**: Field length limits, valid status values, and date format enforcement

### Files Added
- **lib/services/event_import_parser.dart**: JSON parsing and validation service for event imports
- **lib/services/event_import_validator.dart**: Business rule validation and conflict detection service
- **lib/services/event_import_service.dart**: Main import orchestration service with transaction management
- **Extended lib/models/import_models.dart**: Added event-specific import models and result types

## [v0.46.0] - 2025-01-11

### User Requests
- "Seems to be working but I don't like that tags gets normalized to lower case. Please keep the casing (and update the specs)."
- "option 2" - referring to making tags fully case-sensitive throughout the entire app

### Changed
- **Tag Case Sensitivity**: Made tags fully case-sensitive throughout the entire application
  - Tags now preserve their original casing during import from JSON files
  - Database storage maintains exact case instead of normalizing to lowercase
  - Tag matching and lookups are now case-sensitive everywhere
  - Import conflict detection respects case differences between tags

### Technical
- **TagService Updates**: Removed `toLowerCase()` normalization from `createTag()`, `updateTag()`, and `getTagByName()` methods
- **DancerWithTags Model**: Updated `hasTag()` method to use exact case matching instead of case-insensitive comparison
- **Import System**: Removed case normalization from import parser, validator, and service components
- **Consistency**: All tag operations now use exact string matching with trimming only (no case conversion)

### Updated Specifications
- **Feature Documentation**: Updated ImportableDancerFormat.md to specify "Fully case-sensitive" tag behavior
- **Validation Rules**: Tags are now documented as case-sensitive with duplicates removed per dancer

### Files Modified
- **lib/services/tag_service.dart**: Removed toLowerCase() from tag operations, using trim() only
- **lib/models/dancer_with_tags.dart**: Made hasTag() method case-sensitive
- **lib/services/dancer_import_validator.dart**: Removed case normalization from tag validation
- **feature_ImportableDancerFormat.md**: Updated validation rules documentation

## [v0.45.0] - 2025-01-11

### User Requests
- "Let's implement this feature. Add new classes to lib/services/import. Split the ImportService into smalled SRP classes. Remember to include Dancer in the class names to indicate it is about dancers import."

### Added
- **Dancer Import System**: Complete bulk import functionality for dancers from JSON files
  - JSON format support with dancers array and optional metadata section
  - Three conflict resolution strategies: skip duplicates, update existing, import with suffix
  - Automatic tag creation for missing tags during import
  - Comprehensive validation with detailed error reporting
  - Import preview and validation-only mode for safe testing
  - Database transaction safety with automatic rollback on errors

### Technical
- **DancerImportParser**: Handles JSON parsing and data extraction with size limits (1000 dancers max)
- **DancerImportValidator**: Validates import data and detects conflicts with existing dancers
- **DancerImportService**: Main orchestrator for complete import workflow with atomic transactions
- **ImportableDancer Models**: Complete data model set for import operations with proper validation

### Architecture
- **Single Responsibility Principle**: Four focused classes each handling specific import aspects
- **Comprehensive Logging**: Action logging throughout all import operations
- **Error Handling**: Graceful error handling with user-friendly messages
- **Performance Optimized**: Batch operations and efficient database queries
- **Integration Ready**: Compatible with existing DancerService and TagService patterns

### Files Added
- **lib/models/import_models.dart**: Data models for import operations (ImportableDancer, DancerImportResult, etc.)
- **lib/services/dancer_import_parser.dart**: JSON parsing and validation service
- **lib/services/dancer_import_validator.dart**: Conflict detection and validation service  
- **lib/services/dancer_import_service.dart**: Main import orchestration service

## [v0.44.0] - 2025-01-11

### User Requests
- "Let's do that" - referring to updating Dancers screen to use "tap for context actions" pattern

### Improved
- **Consistent UI Pattern**: Updated Dancers screen to use "tap for context actions" pattern
  - Replaced PopupMenuButton with direct tap handler on dancer cards
  - Modal bottom sheet context menu following app-wide conventions
  - Streamlined interaction: single tap opens context menu instead of searching for menu button
  - Enhanced action logging for dancer interactions
  - Improved notification system using ToastHelper for consistent styling

### Changed
- **DancerCardWithTags**: Removed trailing PopupMenuButton, added tap handler with modal bottom sheet
- **User Experience**: All management screens now use identical interaction patterns
- **Visual Consistency**: Clean card design without UI clutter across entire app

### Technical
- Updated DancerCardWithTags component to follow established tap context pattern
- Enhanced action logging for dancer card interactions
- Consistent toast notifications across all dancer management operations
- Unified interaction model across Tags, Ranks, Events, and Dancers screens

## [v0.43.0] - 2025-01-11

### User Requests
- "wrap it up and take first item" - referring to "add option to remove a tag" from Next steps.md

### Added
- **Tag Deletion**: Added ability to delete tags from Tags screen
  - New `deleteTag` method in TagService with automatic cleanup of dancer-tag relationships
  - Delete option in tag context menu with confirmation dialog
  - Cascade deletion automatically removes tag from all dancers
  - Comprehensive logging of deletion operations including usage counts

### Improved
- **Complete Tag Management**: Tags screen now supports full CRUD operations (Create, Read, Update, Delete)
- **Safe Deletion Process**: Confirmation dialog warns users about permanent action and impact on dancers
- **Visual Feedback**: Error-styled delete button and comprehensive user notifications
- **Database Integrity**: Automatic cleanup of related records via cascade constraints

### Technical
- Enhanced TagService with `deleteTag(id)` method following established patterns
- Database cascade delete ensures no orphaned dancer-tag relationships
- Proper error handling and user feedback for all deletion scenarios
- Comprehensive action logging for deletion operations and usage tracking

## [v0.42.0] - 2025-01-11

### User Requests
- "take the first task" - referring to "add a way to edit tag name" from Next steps.md
- "It works but should use 'tap for context actions' pattern"

### Added
- **Tag Editing**: Added ability to edit tag names in Tags screen
  - New `updateTag` method in TagService with proper validation and duplicate checking
  - Context menu on each tag with Edit option in Tags screen
  - Edit dialog similar to other editing patterns in the app
  - Proper error handling and user feedback with snackbars

### Improved
- **Consistent UI Pattern**: Updated Tags screen to use "tap for context actions" pattern
  - Replaced PopupMenuButton with direct tap handler on tag items
  - Modal bottom sheet context menu following app-wide conventions
  - Card-based design consistent with RankEditorScreen and other screens
  - Streamlined interaction: single tap opens context menu instead of two-step process

### Technical
- Enhanced TagService with `updateTag(id, name)` method following same pattern as RankingService
- Updated Tags screen UI with modal bottom sheet context actions
- Added comprehensive logging for tag editing operations
- Validates against duplicate tag names when editing
- Consistent interaction patterns across all management screens

## [v0.41.0] - 2025-01-11

### User Requests
- "I realized that there is no way to navigate to tags screen. Update the spec and impl."
- "The tags screen is too complex. The rows should be just tags names. Also there is no way to add new tag."
- "Great, finish this step"

### Added
- **Tags Screen Navigation**: Added label icon button in Home screen app bar to access Tags management
- **Tag Creation Functionality**: FloatingActionButton with dialog to create new custom tags
- **Comprehensive Tags Management**: Complete interface for viewing and managing all tags in the system

### Improved
- **Simplified Tags UI**: Clean ListTile design showing just tag names with label icons
- **Immediate Tag Creation**: Simple dialog with auto-focus text input for quick tag entry
- **Real-time Updates**: StreamBuilder automatically refreshes tag list when new tags created
- **User Feedback**: Success/error messages via SnackBar for tag creation operations
- **Duplicate Prevention**: TagService handles duplicate tag creation gracefully

### Changed
- **Tag System**: Now supports both predefined (8 tags) and custom user-created tags
- **Navigation Flow**: Direct access to Tags screen from main Home screen app bar
- **UI Complexity**: Removed usage statistics and creation dates for cleaner interface

### Technical
- **TagsScreen Implementation**: Complete screen with add tag dialog and StreamBuilder
- **Home Screen Integration**: Added TagService dependency injection and navigation button
- **Specification Updates**: Updated Implementation specification.md with complete Tags screen documentation
- **Action Logging**: Comprehensive logging for tag creation, navigation, and screen lifecycle
- **Database Integration**: Full CRUD operations through TagService with immediate UI updates

### Files Added
- **lib/screens/tags_screen.dart**: New Tags management screen with creation functionality

### Files Updated
- **lib/screens/home_screen.dart**: Added Tags navigation button and TagService dependency
- **Implementation specification.md**: Complete documentation of Tags screen and navigation flow

## [v0.40.0] - 2025-01-11

### User Requests
- "support an edge case: have a rank A, set a person rank in an event to A, make rank A archived, edit person rank in an event to B -- currently this fails"
- "Maybe let's do that in more generic way, in Edit Rank dialog include all archived ranks that are used by the current event."

### Fixed
- **Archived Rank Edit Bug**: Fixed critical bug where editing rankings failed when the current rank was archived
- **Ranking Dialog Crash**: Resolved `firstWhere()` exception when trying to edit rankings assigned to archived ranks
- **Type Casting Error**: Fixed "type 'int' is not a subtype of type 'String'" error by converting raw SQL to Drift expressions
- **Data Integrity**: Ensured users can always view and modify their existing rankings, even when ranks are later archived

### Improved
- **Generic Archived Rank Support**: Enhanced ranking dialog to include ALL archived ranks currently used by anyone in the event
- **Consistent User Experience**: All users editing rankings in the same event now see the same available rank options
- **Complete Flexibility**: Users can assign any rank that's already in use for the event, including archived ones
- **Visual Feedback**: Added "ARCHIVED" badge to distinguish archived ranks in ranking dialogs
- **Concise UI Text**: Shortened archived rank subtitle to "Archived (in use)" for better readability
- **Enhanced Logging**: Improved action logging with detailed counts of active vs archived ranks available
- **Query Performance**: Optimized database queries using proper Drift joins instead of raw SQL

### Technical
- **Smart Rank Loading**: `RankingDialog` now queries all event rankings to find archived ranks in use
- **Optimized Performance**: Single query to get all used rank IDs, then filter archived ranks efficiently
- **Better Context**: Updated subtitle text to explain why archived ranks are shown (event usage vs personal usage)
- **Future-Proof**: Solution handles multiple people having different archived ranks in the same event
- **Drift Migration**: Converted `getRankingsForEvent` from raw SQL to proper Drift expressions with inner joins
- **Type Safety**: Eliminated type casting issues by using Drift's built-in type system

## [v0.39.0] - 2025-01-11

### User Requests
- "make the toast notification disapear quicker by themselfes and right away when tapped by user"

### Added
- **Improved Toast Notifications**: Complete redesign of notification system with enhanced user experience
- **Tap-to-Dismiss**: Toast notifications now disappear immediately when tapped anywhere on the message
- **Close Button**: Added ✕ button for explicit dismissal option
- **Floating Design**: Modern floating toast style with rounded corners and margins
- **Swipe Dismissal**: Horizontal swipe gesture support for quick dismissal

### Improved
- **Faster Auto-Dismiss**: Reduced duration from 4 seconds to 2 seconds for quicker experience
- **Better Visual Feedback**: Consistent color coding (success/error/warning/info) across all notifications
- **Enhanced Accessibility**: Multiple dismissal methods (tap, swipe, button, automatic)
- **User-Friendly Interface**: Clear visual cues and immediate response to user interactions

### Changed
- **Toast Duration**: Notifications now auto-dismiss in 2 seconds instead of default 4 seconds
- **Interaction Model**: Single tap anywhere on notification dismisses it immediately
- **Visual Style**: Floating notifications with rounded corners and proper spacing
- **Consistent API**: Unified ToastHelper with showSuccess(), showError(), showWarning(), showInfo() methods

### Technical
- **ToastHelper Utility**: New centralized toast notification system replacing scattered SnackBar usage
- **Performance**: Automatic clearing of existing notifications prevents stacking issues
- **Code Consistency**: Updated all screens and dialogs to use standardized toast system
- **Maintainability**: Single source of truth for notification styling and behavior

### Files Updated
- **Core Screens**: HomeScreen, RankEditorScreen, DancersScreen notification improvements
- **Dialog Components**: AddDancerDialog, RankingDialog, DancerActionsDialog enhanced notifications
- **Service Integrations**: All service layer notifications use improved toast system
- **Comprehensive Coverage**: 50+ notification points updated across entire application

## [v0.38.0] - 2025-01-11

### User Requests
- "run the app on my Samsung phone"
- "Ok, it does not work. Let's package the app and send it to device as archive manually."

### Added
- **Mobile Deployment**: Successfully deployed app to Samsung Android device
- **APK Generation**: Built optimized release APK (24.7MB) for manual installation
- **Android Production Ready**: Full Android compatibility with all features working

### Improved
- **Mobile Experience**: Dancer Ranking App now fully functional on mobile devices
- **Deployment Workflow**: Established APK build and manual installation process
- **Cross-Platform Reach**: App now accessible beyond desktop environment

### Technical
- **Android SDK Setup**: Completed Android toolchain configuration with licenses
- **Release Build**: Generated optimized APK with tree-shaking (99.7% icon reduction)
- **NDK Compatibility**: Resolved Android NDK version requirements for dependencies
- **Manual Installation**: Successful APK installation and verification on Samsung device

### Milestone
- **🎉 Mobile Launch**: Dancer Ranking App successfully running on Android phone
- **Production Deployment**: First mobile device deployment complete
- **User Validation**: All core features confirmed working on Samsung phone

## [v0.37.0] - 2025-01-11

### User Requests
- "use FAB instead of AppBar for Add action in Ranks screen"
- "I dont want long press, it is too slow to use"

### Improved
- **Better Accessibility**: FloatingActionButton for adding ranks provides clearer call-to-action
- **Modern UI Pattern**: FAB follows Material Design standards for primary actions
- **Consistent UI Pattern**: Maintained long press + modal bottom sheet pattern matching other screens
- **App-wide Consistency**: All context menus now use the same interaction pattern

### Changed
- **Add Rank Action**: Moved from AppBar action to FloatingActionButton
- **Rank Context Menu**: Single tap opens modal bottom sheet with all actions (Edit, Archive, Delete)
- **Instructions Text**: Updated to "Tap for options" for clear single-action interface
- **User Experience**: Simplified interaction with single tap for all rank actions

### Fixed
- **Context Disposal Error**: Completely resolved FlutterError "Looking up a deactivated widget's ancestor is unsafe"
  - Fixed all rank operations (Edit, Archive/Unarchive, Delete) to use main widget context
  - Eliminated dialog context passing that caused widget disposal issues
  - Restructured async operations to close dialogs before performing actions
  - Enhanced error handling for widget lifecycle management

### Improved  
- **Archive/Unarchive Logic**: Dynamic context menu shows "Archive" or "Un-archive" based on current state
- **Smart Actions**: Archived ranks show "Un-archive" action, active ranks show "Archive" action
- **Visual Feedback**: Different colors and messages for archive vs unarchive operations

### Technical
- **RankEditorScreen**: Removed AppBar actions array, added FloatingActionButton
- **_RankCard**: Single tap opens context menu with all actions (Edit, Archive/Unarchive, Delete)
- **Context Lifecycle**: Proper context management in async operations to prevent disposal errors
- **Archive State Management**: Dynamic UI based on rank.isArchived state with appropriate service calls

## [v0.36.0] - 2025-01-11

### User Requests
- "When I open the ranks screen I get 'nullcheck operator used on null value'"
- "Nice. Next - there is no point in displaying the priority value, the order of the rows is enough."
- "Good, remove also the blue circle with the ordinal number from the rows"
- "Great. Let's keep the UI patterns aligned between screen. Double check the new screen with existing screens."
- "great progress, let's finish this step"

### Fixed
- **Database Migration Issue**: Fixed "nullcheck operator used on null value" error in rank editor
- **Schema Migration**: Added proper v2 to v3 database migration for new Ranks table fields
- **Null Safety**: Enhanced null handling for isArchived, createdAt, updatedAt fields

### Improved
- **Cleaner Rank Editor UI**: Removed redundant priority numbers from rank display
- **Minimalist Design**: Removed circular ordinal number indicators for streamlined appearance
- **Visual Hierarchy**: Position order now clearly communicated through visual sequence alone
- **Consistent UI Patterns**: Standardized interaction patterns across all screens

### Changed
- **Dancers Screen**: Replaced PopupMenuButton with long press gesture and modal bottom sheet
- **Context Menu Consistency**: All screens now use long press → modal bottom sheet pattern
- **Card Design**: Unified clean card design without visual clutter across app
- **Instructions**: Simplified to "Drag to reorder priority. Tap to edit, long press for options."

### Technical
- **Database Schema**: Updated to version 3 with proper migration for Ranks table
- **Migration Handler**: Added _migrateRanksTable method with default values for existing data
- **UI Consistency**: Aligned all card components to use GestureDetector with onLongPress
- **Modal Bottom Sheets**: Standardized context menu implementation across screens

## [v0.33.0] - 2025-01-11

### User Requests
- "Let's implement next step" - referring to "Import ranking from another event"
- "the rationale is that similar set of people come to similar type of event"

### Added
- **Import Rankings Feature**: Complete functionality to copy rankings from one event to another
- **Event Context Menu Integration**: Added "Import Rankings" option to event long-press context menu
- **Source Event Selection**: Dialog allowing users to select which event to import rankings from
- **Conflict Handling**: Option to overwrite existing rankings or skip dancers who already have rankings
- **Smart Filtering**: Only show events with existing rankings as source options
- **Comprehensive Logging**: Full action tracking throughout import process
- **User Feedback**: Success/warning messages with detailed import statistics

### Technical
- **RankingService.importRankingsFromEvent()**: New method with conflict resolution
- **ImportRankingsResult**: Helper class for structured import feedback
- **ImportRankingsDialog**: Reusable dialog component for source event selection
- **Automatic UI Updates**: StreamBuilder automatically refreshes when rankings imported

## [v0.33.1] - 2025-01-11

### User Requests
- "Nice, but I would rather have it as an action on the Planning tab in the event screen when there are no dancers added to event ranking yet"

### Improved
- **Better UX Placement**: Moved "Import Rankings" from home screen context menu to Planning tab
- **Contextual Availability**: Only shows when in event with no dancers added yet
- **Cleaner Integration**: Appears as button in empty state rather than context menu option
- **More Intuitive Flow**: Access import feature directly when setting up event rankings

### Changed
- **Removed**: "Import Rankings" option from event context menu in home screen
- **Added**: "Import Rankings" button in Planning tab empty state
- **Location**: Planning tab now shows import option when totalRankedDancers == 0

### Technical
- **Planning Tab Enhancement**: Added _showImportRankingsDialog method to PlanningTab
- **Import Management**: Proper error handling and event name fetching
- **UI Consistency**: Maintains same dialog behavior with improved placement

## [v0.33.2] - 2025-01-11

### User Requests
- "Nice, but this 'imported from another event' is not needed"

### Improved
- **Cleaner Import Reasons**: Removed automatic "Imported from another event:" prefix from ranking reasons
- **Original Context Preserved**: Import process now preserves original ranking reasons exactly as they were
- **Less Clutter**: Ranking reasons remain clean and focused on the actual reasoning

### Changed
- **Ranking Import**: No longer adds import prefix to ranking reasons
- **Data Preservation**: Original reasons from source event are copied verbatim

### Technical
- **RankingService.importRankingsFromEvent()**: Removed reason prefix logic
- **Data Integrity**: Direct copying of reason field without modification

## [v0.32.0] - 2025-01-11

### User Requests
- "Ok, double check that all actions emmit logs"
- Request to verify comprehensive logging coverage across entire application

### Added
- **Complete Action Coverage**: Added ActionLogger to all missing UI components and user interactions
- **Home Screen Logging**: Navigation actions, event card interactions, context menus (rename, delete, change date)
- **Dialog Lifecycle Logging**: AddDancerDialog, DanceRecordingDialog, RankingDialog, CreateEventScreen with full workflow tracking
- **Service Method Enhancement**: Comprehensive logging for DancerService and EventService CRUD operations
- **Database Operation Tracking**: Enhanced error handling and success logging for all data operations
- **Form Interaction Logging**: Validation failures, form submissions, field changes with detailed context
- **Navigation Traceability**: Screen initialization, disposal, tab changes, route parameters

### Enhanced
- **Dancer Card Interactions**: Complete tap action logging with dancer state context
- **Context Menu Actions**: Full workflow tracking for event management operations  
- **Error Context**: Improved error logging with operational parameters and failure reasons
- **Data Flow Visibility**: Service calls, database operations, and state transitions with timestamps

### Technical
- **100% Action Coverage**: Every user interaction now emits structured logs
- **Debugging Ready**: Complete action traceability for bug reproduction and workflow analysis
- **Structured Format**: Consistent logging categories with timestamps and contextual data
- **Performance Optimized**: Efficient logging without impacting user experience

## [v0.31.0] - 2025-01-11

### User Requests
- "add a structured action log to every action, printed to console, so that I can review what exact actions led to a bug"
- "print all list items that got rendered (some short info including ID)"
- "use format that will be easy to process by Cursor agent"

### Added
- **Centralized Action Logger**: New `ActionLogger` utility with structured, timestamp-based logging format
- **Comprehensive Service Logging**: All database operations (CRUD) tracked with detailed context
- **List Rendering Logs**: All UI lists log their rendered items with IDs and key properties
- **User Interaction Tracking**: Context menu actions, dialog lifecycle, navigation events
- **Screen Lifecycle Logging**: Screen initialization, disposal, tab changes with full context
- **Error Context Logging**: Enhanced error tracking with operation context and parameters

### Technical
- **Logging Categories**: `[ACTION_LOG]`, `[LIST_LOG]`, `[STATE_LOG]`, `[ERROR_LOG]` for easy parsing
- **Service Integration**: DancerService, AttendanceService, RankingService with method-level logging
- **UI Component Logging**: Planning/Present tabs, DancerActionsDialog, EventScreen with interaction tracking
- **Cursor Agent Friendly**: Structured format designed for easy automated analysis
- **Performance Optimized**: Uses both `developer.log()` and `print()` for comprehensive coverage
- **Context Rich**: Each log includes relevant IDs, status changes, filtering results, and user actions

### Debugging Enhancement
- **Bug Reproduction**: Complete action trail for recreating user workflows
- **Data Flow Tracking**: Database operations with before/after states
- **UI State Visibility**: List contents, filtering results, navigation patterns
- **Error Context**: Full parameter context when operations fail
- **Workflow Analysis**: End-to-end user interaction patterns

## [v0.30.0] - 2025-01-11

### User Requests
- rename "Remove from Present" to "Mark absent"
- remove "Remove from event" from menu when the Present tab is active

### Improved
- **Context Menu Text**: Renamed "Remove from Present" to "Mark absent" for clearer terminology
- **Tab-Specific Actions**: "Remove from event" action only shows in Planning tab now
- **User Experience**: Context menus are now more intuitive with tab-appropriate actions
- **Consistent Feedback**: Updated snackbar message to reflect "marked as absent" terminology

### Technical
- Modified DancerActionsDialog to use "Mark absent" instead of "Remove from Present"
- Added `isPlanningMode` condition to "Remove from event" action visibility
- Updated snackbar message for absence marking to match new terminology
- Enhanced tab-specific UI behavior for better user workflow

## [v0.29.0] - 2025-01-11

### User Requests
- "add long press context menu to events screen" with "Rename" and "Delete"
- "Make sure the list gets refreshed after the contextual action"
- "When I confirm the date picker dialog after changing the date it does not get changed in events screen"
- "Still no good. Write it down as a bug to address later."

### Added
- **Long Press Context Menu**: Added long press gesture to event cards showing bottom sheet menu
- **Rename Event Action**: Full rename functionality with text field dialog and validation
- **Delete Event Action**: Delete with confirmation dialog and cascade deletion of related data
- **Change Date Action**: UI for date picker (functional but has database update bug)

### Improved
- **Event Management**: Enhanced event cards with contextual actions for better user control
- **Visual Feedback**: Comprehensive snackbar notifications for all actions with success/error states
- **Error Handling**: Proper try-catch blocks with user-friendly error messages
- **Input Validation**: Trim whitespace and prevent empty names in rename dialog

### Technical
- Added modal bottom sheet context menu with three actions (Rename, Change Date, Delete)
- Implemented separate dialog methods for each action with proper state management
- Enhanced EventService.updateEvent method with better field preservation
- Added keyboard shortcut support (Enter key) for rename dialog
- Proper async/await handling and context.mounted checks for navigation safety

### Known Issues
- **Date Change Bug**: Date picker selection doesn't persist to database (needs investigation)
  - UI shows date picker and success message but database update fails
  - May be related to DateTime comparison or Drift ORM update method

## [v0.28.1] - 2025-01-11

### User Requests
- "why the title and subtitle is not centered?"

### Fixed
- **AppBar Alignment**: Fixed title and subtitle alignment to be properly centered
- **Visual Consistency**: AppBar content now aligns with Material Design standards and theme settings

### Technical
- Changed Column crossAxisAlignment from CrossAxisAlignment.start to CrossAxisAlignment.center
- Leverages existing centerTitle: true theme setting for proper alignment
- Applied proper Dart formatting to modified file

---

## [v0.28.0] - 2025-01-11

### User Requests
- "It looks like you have modified the AppBar while shinking the tabs header. Please revert this."
- "Great, but I want the AppBar to be the standard size and the tab header to have minimal hight"
- "Can AppBar have subtitle?" "Let's try the first one" (Column approach)
- "Let's go for option one, use a more compact date format, I don't need the year part"
- "Is there an alternative component similar to Tabs but with a header indicator flowing over the tab content?"
- "try thrird one" (Material 3 style), "Let's try the first approach instead."
- "Nah, still to much vertical space. Try option 2.", "Hmm, let's keep the PageController and remove the tabs header."
- "Great. Now we need some indicator of the current tab. Let's use the AppBar subtitle for that."
- "Let's list all tabs in the subtitle and mark somehow the active one"
- "Don't use color for that. Use some characters instead."

### Improved
- **Clean Navigation Design**: Removed tab header entirely for maximum vertical space efficiency
- **AppBar Subtitle Navigation**: Added subtitle showing both tabs with bracket indicators for active tab
- **Swipe-Only Navigation**: Pure swipe gesture navigation using PageController instead of TabController
- **Compact Date Format**: Event date shows as "MMM d" format without year for cleaner appearance
- **Bullet Separator**: Used bullet (•) separator between event name and date for modern look
- **Character-Based Indicators**: Active tab marked with brackets [Planning] • Present for accessibility

### Technical
- **Navigation Architecture**: Replaced TabController with PageController for swipe-only navigation
- **State Management**: Added _currentPage tracking for subtitle updates
- **AppBar Structure**: Title reduced to 16px, subtitle at 12px with dynamic tab indication
- **Removed Components**: Eliminated PreferredSize wrapper, TabBar, and all tab styling
- **Gesture Navigation**: onPageChanged callback updates current page state for subtitle
- **Character Formatting**: Dynamic string formatting shows active tab in brackets

---

## [v0.27.3] - 2025-06-29

### User Requests
- "remove 'left before dancing' subtitle as it is redundant"

### Improved
- **Cleaner Dialog Interface**: Removed redundant subtitle "left before dancing" from "Mark as left" action
- **Simplified UI**: Action text "Mark as left" is clear enough without additional explanation
- **Reduced Visual Clutter**: Streamlined Dancer Actions Dialog for better usability

### Technical
- Removed subtitle property from "Mark as left" ListTile in DancerActionsDialog
- Applied proper Dart formatting to modified file
- Maintained all functionality while simplifying UI text

---

## [v0.27.2] - 2025-06-29

### User Requests
- "Try to reduce spacing around the tab title, keeping the text size the same"
- "As I don't need to tap them, I will use swiping"

### Improved
- **Swipe-Optimized Tab Header**: Reduced to 14px height optimized for swipe-only navigation
- **Zero-Padding Design**: Eliminated all unnecessary padding since touch targets not needed
- **Minimal Text Spacing**: Only 2px vertical padding around text for readability
- **Maximum Space Efficiency**: 71% smaller than original while maintaining 10px text size

### Technical
- PreferredSize height reduced to 14px (from 18px) 
- labelPadding set to EdgeInsets.zero for swipe-only usage
- indicatorPadding reduced to 4px horizontal (from 8px)
- indicatorWeight reduced to 1.0px for minimal visual weight
- Line height compressed to 0.8 for tightest text layout
- Added Padding widgets around text with 2px vertical spacing

---

## [v0.27.1] - 2025-06-29

### User Requests
- "Seems to be working, shrink it twice more"

### Improved
- **Ultra Compact Tab Header**: Further reduced tab bar height from 28px to 18px (62% smaller than original)
- **Micro Typography**: Reduced font size to 10px for maximum space efficiency
- **Minimal Spacing**: Ultra-thin padding (1px vertical) and narrow indicator (1.5px weight)
- **Extreme Space Savings**: Now uses ~63% less vertical space than original Material Design tabs

### Technical
- PreferredSize height reduced to 18px (down from 28px)
- labelPadding reduced to 1px vertical (from 4px)
- Font size reduced to 10px (from 13px)
- indicatorWeight set to 1.5px for ultra-thin appearance
- Line height compressed to 0.9 for tightest possible layout

---

## [v0.27.0] - 2025-06-29

### User Requests
- "Let's revise this. For the accessibility I can just swipe left and right to switch the tabs. But the tabs header is too big. Is there some more compact tabs header?"

### Improved
- **Compact Tab Header**: Reduced tab bar height from ~48px to 36px for significant vertical space savings
- **Optimized Typography**: Smaller font sizes (14px) with proper weight differentiation for selected/unselected tabs
- **Better Spacing**: Reduced padding while maintaining touch targets and visual clarity
- **Preserved Functionality**: Maintains all swipe gestures and tab switching behavior

### Technical
- Wrapped TabBar in PreferredSize widget to control exact height (36px)
- Added custom labelPadding (vertical: 8px) and indicatorPadding (horizontal: 16px)
- Implemented custom labelStyle and unselectedLabelStyle for typography optimization
- Maintained accessibility standards while reducing visual footprint

## [v0.26.0] - 2025-06-29

### User Requests
- "please continue" (from Next steps: "for the dancer I have danced with show an 'Edit impression' action text instead of 'Record dance', keep the action implementation the same")

### Improved
- **Context-Aware Action Text**: Action text now shows "Edit impression" for dancers already danced with and "Record Dance" for new dances
- **Better User Experience**: More accurate action labels that reflect the actual operation being performed
- **Consistent Functionality**: Same dialog and behavior, just clearer labeling based on dance status

### Technical
- Updated Dancer Actions Dialog to conditionally display action text based on `dancer.hasDanced` status
- Changed from static "Record Dance" text to dynamic text using ternary operator
- Functionality remains identical - still opens DanceRecordingDialog for both cases

## [v0.25.0] - 2025-06-29

### User Requests
- "If the person left, there is no point in showing them in the Present tab"

### Improved
- **Present Tab Filtering**: Dancers who have left the event are no longer shown in the Present tab
- **Logical Display**: Present tab now only shows dancers with status 'present' or 'served', excluding those marked as 'left'
- **Cleaner Interface**: Removes visual clutter from dancers who are no longer available for interaction
- **Better Empty State**: Updated empty state message from "No one marked present yet" to "No one currently at the event"

### Technical
- Modified Present tab filtering logic to exclude dancers with status='left'
- Changed filter from `d.isPresent` to `d.status == 'present' || d.status == 'served'`
- Updated empty state messaging for better accuracy
- Applied proper Dart formatting to modified files

## [v0.24.0] - 2025-06-29

### User Requests
- "continue" (from Next steps: "add an action to mark a present dancer as 'left' when they leave before I danced with them")

### Added
- **Mark as Left Action**: New action to mark present dancers as 'left' when they leave before dancing
- **Smart Visibility**: Action only appears for present dancers who haven't been danced with yet
- **Visual Indication**: "Left" status now displays in dancer cards with warning color
- **Accurate Tracking**: Better overview of who was present vs who you actually danced with

### Improved
- **Event Management**: Can now track dancers who left early vs those you danced with
- **Clear Status Display**: Dancer cards show "Left" indicator for departed dancers
- **Contextual Actions**: Intelligent action visibility prevents marking danced dancers as left
- **Better Analytics**: Maintains complete record of who was present vs who you engaged with

### Technical
- Added `markAsLeft()` method to AttendanceService with validation
- Added "Mark as left" action to Dancer Actions Dialog with conditional visibility
- Updated DancerCard to display "Left" status with warning theme color
- Action only shows when `dancer.isPresent && !dancer.hasDanced` for logical consistency
- Leverages new status field architecture from v0.23.0 schema refactoring

---

## [v0.23.0] - 2025-06-29

### User Requests
- "Implement next step" (from Next steps: "Refactor the attendance record to have a status field instead of hasDanced")

### Changed
- **Database Schema Migration**: Replaced `hasDanced` boolean field with `status` text field in attendances table
- **Status Values**: Now supports "present", "served", "left", and "absent" states instead of just true/false
- **Enhanced Tracking**: Better semantic representation of dancer states throughout event lifecycle

### Added
- **New Status Field**: Attendances table now uses status enum: present, served, left, absent
- **Database Migration**: Automatic migration from v1 to v2 schema preserving existing data
- **Backward Compatibility**: Added convenience getters (`hasDanced`, `hasLeft`, `isAbsent`) for existing code
- **Future Extensibility**: Framework for tracking dancers who left before being asked to dance

### Technical
- **Schema Version**: Bumped database schema from v1 to v2
- **Migration Logic**: Custom migration preserves existing hasDanced=true as status='served', hasDanced=false as status='present'
- **Service Layer Updates**: Updated AttendanceService, DancerService to use status field
- **SQL Query Updates**: Modified custom queries to use status='served' instead of has_danced=1
- **Class Updates**: Updated DancerWithEventInfo and AttendanceWithDancerInfo to use status
- **Compatibility Getters**: Maintained `hasDanced` getter for seamless transition

---

## [v0.22.1] - 2025-06-29

### User Requests
- "Nice, just the new action has too much text. 'Remove from event' will do."

### Improved
- **Cleaner UI Text**: Simplified "Remove from Planning" action to "Remove from event"
- **Reduced Clutter**: Removed subtitle text for cleaner dialog interface
- **Consistent Messaging**: Updated snackbar feedback to match new action text

### Technical
- Updated Dancer Actions Dialog title from "Remove from Planning" to "Remove from event"
- Removed subtitle "Remove ranking for this event" for cleaner appearance
- Updated snackbar message to match new terminology

---

## [v0.22.0] - 2025-06-29

### User Requests
- "Do next item" (from Next steps: "Add a contextual action to remove a person from planned tab")

### Added
- **Remove from Planning Action**: Added contextual action to remove dancers from event planning
- **Planning Management**: Users can now remove ranking assignments for dancers from the Planning tab
- **Clean Workflow**: Remove dancers who no longer need to be ranked for specific events

### Improved
- **Flexible Planning**: Easy way to clean up planning lists by removing unwanted rankings
- **Contextual Actions**: New action only appears for ranked dancers, maintaining clean interface
- **Immediate Feedback**: Clear visual confirmation when dancers are removed from planning

### Technical
- Added "Remove from Planning" action to Dancer Actions Dialog
- Implemented `_removeFromPlanning()` method using `RankingService.deleteRanking()`
- Action only shows when `dancer.hasRanking` is true
- Proper error handling with user feedback via snackbars
- Added RankingService import to dancer_actions_dialog.dart

---

## [v0.21.0] - 2025-06-29

### User Requests
- "Nice, but now when I mark single dancer as present it is not reflected in Add Existing Dancer dialog."

### Fixed
- **Reactive List Updates**: Fixed Add Existing Dancer screen to automatically update when dancers are marked as present
- **Real-time UI Updates**: Converted from FutureBuilder to StreamBuilder for reactive data updates
- **Immediate Feedback**: Dancers now disappear from the list immediately after being marked present

### Technical
- Replaced `FutureBuilder` with `StreamBuilder` in Add Existing Dancer screen
- Changed `_getAvailableDancers()` Future method to `_getAvailableDancersStream()` Stream method
- Uses reactive `watchDancersForEvent()` with filtering for unranked and absent dancers
- Automatic UI updates when attendance database changes occur

---

## [v0.20.0] - 2025-06-29

### User Requests
- "all the contextual dialogs should close after picking an action. The 'add absent existing dancers' screen should stay so I can mark multiple people."

### Improved
- **Persistent Add Existing Dancer Screen**: Users can now mark multiple dancers as present without the screen closing
- **Enhanced Bulk Operations**: Efficient workflow for marking multiple absent dancers as present during events
- **Contextual Dialog Behavior**: Ensured all action dialogs close after picking an action as expected
- **Shorter Feedback Duration**: Reduced snackbar duration to 1 second for faster bulk operations

### Technical
- **AddExistingDancerScreen**: Removed `

## [v0.9.1] - 2025-06-30

### User Requests
- "Let's remove duplication from the newly added code in attendance_service.dart" - Refactor to eliminate code duplication

### Technical
- **Code Deduplication**: Refactored AttendanceService to eliminate duplicate code
  - Created `_createAttendanceDancerJoinQuery()` helper method to centralize join query setup
  - Created `_mapJoinResultsToAttendanceWithDancerInfo()` helper method to centralize result mapping
  - Reduced code duplication between `getPresentDancersWithInfo()` and `getDancedDancers()` methods
  - Improved maintainability by centralizing common join and mapping logic

### Improved
- **Code Maintainability**: Eliminated duplicate join query setup and result mapping code
- **DRY Principle**: Applied "Don't Repeat Yourself" principle to service layer methods

## [v0.9.0] - 2024-12-19

### User Requests
- "Let's work on this. Write down a design first and let me review it" - referring to Tags on persons feature from Roadmap
- "That is too long. Start simple." - requested simplified design approach
- "In the edit dancer dialog I don't want to input text. I'd rather have a paragraph of tag pill I can turn on and off." - specified pill-based UI
- "I want to see tags on Dancers screen but not on Event screen" - clarified tag display scope
- "Make sure the files you modified did not become too complex and big. Consider extracting classes to separate files." - requested code refactoring

### Added
- **Tags on Persons feature** with core functionality:
  - Database schema with `tags` and `dancer_tags` tables for many-to-many relationships
  - 8 predefined tags: regular, occasional, rare, new, dance-class, dance-school, workshop, social
  - TagService for all tag-related CRUD operations
  - Tag selection using toggleable pill interface in Add/Edit Dancer dialog
  - Tag display as colored chips on main Dancers screen only (not on event screens)
  - DancerWithTags model for combining dancer and tag data
  - Enhanced DancerService with tag-aware methods

### Technical
- Added database migration from schema v3 to v4 for new tag tables
- Created reusable `TagSelectionWidget` component (122 lines)
- Created reusable `DancerCardWithTags` component (106 lines)
- Refactored `AddDancerDialog` from 384 to 292 lines (-24% reduction)
- Refactored `DancersScreen` from 318 to 209 lines (-34% reduction)
- Improved code organization with focused, single-responsibility components
- Maintained existing functionality while adding tag capabilities

### Changed
- Enhanced Add/Edit Dancer dialog with tag selection pills
- Updated Dancers screen to display tags as chips under dancer names
- Modified database schema version to support tags

## [v0.8.0] - 2024-12-18

## [v0.48.0] - 2024-12-28

### User Requests
- Simplify Event Import further by always creating missing dancers automatically

### Changed
- **Event Import Options**: Removed `createMissingDancers` option - missing dancers are now always created automatically
- **UI Design**: Simplified import options step to only show validation-only checkbox
- **Documentation**: Updated design documents to reflect fully automatic behavior

### Technical
- Removed `createMissingDancers` field from `EventImportOptions` model
- Updated validator to always create missing dancers without user intervention
- Removed unused `_checkMissingDancers` method from validator
- Updated service layer to always create missing dancers during import
- Updated UI design specification for simplified options flow

### Improved
- **User Experience**: Zero decision points for missing dancers - fully automatic handling
- **Import Flow**: Streamlined import process with fewer configuration options
- **Code Quality**: Removed unused code and simplified validation logic

## [v0.49.0] - 2024-12-28

### User Requests
- Remove "Validation only" option to further simplify Event Import

### Changed
- **Event Import Flow**: Simplified from 4-step to 3-step process (File Selection → Preview → Results)
- **Import Options**: Removed `validateOnly` option - all imports are performed immediately
- **UI Design**: Eliminated options step entirely, no configuration needed

### Technical
- Removed `validateOnly` field from `EventImportOptions` model
- Simplified service layer by removing validation-only mode logic
- Updated UI design specification to reflect 3-step flow
- Removed `ImportInfoWidget` component specification (no longer needed)

### Improved
- **User Experience**: Maximum simplification - zero configuration options needed
- **Import Flow**: Streamlined to essential steps only
- **Code Quality**: Removed unnecessary validation-only complexity

## [v0.50.0] - 2024-12-28

### User Requests
- Implement Phase 1 of Event Import UI feature

### Added
- **Event Import Dialog**: Complete 3-step import process (File Selection → Preview → Results)
- **Event File Selection Step**: JSON file picker with event-specific validation and requirements
- **Event Data Preview Step**: Rich preview with statistics, expandable event cards, and attendance details
- **Event Results Step**: Comprehensive import summary with statistics, skipped events, and error reporting
- **Home Screen Integration**: Added "Import Events" option to overflow menu in events list

### Technical
- Created `ImportEventsDialog` widget with stepper navigation and progress tracking
- Implemented `EventFileSelectionStep` component with 5MB file size limit and JSON validation
- Built `EventDataPreviewStep` with expandable event cards showing attendances and color-coded statuses
- Developed `EventResultsStep` with detailed statistics, automatic behavior notifications, and action buttons
- Integrated Event Import into home screen with proper provider setup and error handling
- Added comprehensive logging and toast notifications for user feedback

### Improved
- **User Experience**: Streamlined 3-step import process with no configuration needed
- **Data Visibility**: Rich preview showing events, attendances, and unique dancers before import
- **Error Handling**: Clear error messages and validation feedback throughout import process
- **Automatic Behavior**: Visual indicators showing duplicate skipping and missing dancer creation

### UI Components
- File selection with drag-and-drop style interface and clear requirements
- Statistics cards showing import counts and affected data
- Expandable event cards with attendance status icons and color coding
- Progress indicators during import with operation status updates
- Success/warning/error cards with appropriate styling and messaging