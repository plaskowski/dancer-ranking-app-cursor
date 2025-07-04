# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

## [v1.3.3] - 2025-01-17

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
- "I would like to make use of icons from material 3" - Request to implement Material 3 icons throughout the app

### Added
- **Material 3 Icons Implementation**: Comprehensive Material 3 icon system with proper variants and styling
  - **Icon Variants**: Implemented filled, outlined, rounded, sharp, and two-tone icon variants
  - **Color Guidelines**: Established semantic color usage with colorScheme integration
  - **Size Guidelines**: Defined standard sizes (18, 24, 32, 48) for different contexts
  - **Best Practices**: Created comprehensive guide for consistent icon usage across the app
  - **Migration Examples**: Updated existing icons to follow Material 3 conventions
  - **Documentation**: Added detailed Material 3 Icons Guide with examples and best practices

### Improved
- **Icon Consistency**: Updated navigation, action, and status icons to use Material 3 variants
  - **Navigation Icons**: Updated home app bar to use outlined variants (people_outlined, settings_outlined)
  - **Action Icons**: Updated context menus to use outlined variants (edit_outlined, delete_outline)
  - **Status Icons**: Updated archive/restore icons to use outlined variants
  - **Event Icons**: Updated event card actions to use Material 3 variants
  - **Visual Hierarchy**: Better distinction between primary and secondary actions through icon variants
  - **Accessibility**: Improved contrast and semantic color usage for better accessibility

### Technical
- **Icon System Architecture**: Created Material3IconsGuide class with common icons mapping
- **Color Scheme Integration**: All icons now use Theme.of(context).colorScheme for consistent theming
- **Variant Selection**: Implemented proper variant selection based on action type and context
- **Code Organization**: Created dedicated theme file for Material 3 icon utilities and examples
- **Documentation**: Comprehensive guide with implementation examples and migration strategies
- **Formatting**: Applied proper Dart formatting to all modified files

### Documentation
- **Material 3 Icons Guide**: Created comprehensive documentation with examples and best practices
- **Implementation Examples**: Added practical examples for navigation, action, and status icons
- **Migration Guide**: Documented process for updating existing icons to Material 3 standards
- **Best Practices**: Established guidelines for icon variant selection and color usage
