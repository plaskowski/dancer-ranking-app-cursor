# Changelog

All notable changes to the Dancer Ranking App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [v0.19.0] - 2025-06-29

### User Requests
- "let's go" (from Next steps: "I want to try out this as an Android app")
- "Wow, it worked out of the box and all things are working as expected"

### Added
- **Android Platform Support**: Successfully deployed and tested the Dancer Ranking App on Android
- **Cross-Platform Compatibility**: App now runs on both macOS and Android with full functionality
- **Android Emulator Setup**: Configured and tested with Pixel 3a API 34 emulator

### Improved
- **Platform Reach**: Users can now access the app on Android devices and emulators
- **Mobile Experience**: All features (database, UI, navigation) work seamlessly on Android
- **Development Workflow**: Established Android development and testing environment

### Technical
- **Android SDK Configuration**: Located and configured existing Android SDK at `/Users/plaskowski/Library/Android/sdk`
- **Emulator Setup**: Successfully launched `Pixel_3a_API_34_extension_level_7_arm64-v8a` emulator
- **Flutter Build**: Clean Android build with no platform-specific issues
- **Database Compatibility**: SQLite with Drift library works perfectly on Android
- **UI Rendering**: Material 3 design system renders correctly on Android
- **All Features Verified**: Event management, dancer cards, ranking system, and navigation all functional

---

## [v0.18.0] - 2025-06-29

### User Requests
- "continue" (from Next steps: "Let's try save some vertical space - add all notes in the person card right after the person name")

### Changed
- **Compact Dancer Cards**: Redesigned dancer cards to display all information inline after the dancer's name
- **Single-Line Layout**: Converted from multi-line subtitle with Column to inline RichText with bullet separators

### Improved
- **Vertical Space Efficiency**: Significantly reduced card height by eliminating multiple subtitle rows
- **Cleaner Design**: Information flows naturally in a single line: "Name • Notes • Ranking • Dance Status"
- **Better Screen Utilization**: More dancers visible on screen without scrolling

### Technical
- Updated `lib/widgets/dancer_card.dart` with inline RichText layout
- Replaced Column subtitle structure with single RichText widget using TextSpan elements
- Used bullet separators (•) between different information types for readability
- Maintained all conditional logic for showing/hiding information based on dance status
- Fixed text color to use theme-aware `onSurface` color for dark mode compatibility

---

## [v0.17.0] - 2025-06-29

### User Requests
- "continue" (from Next steps: "in the present tab don't show the general note and ranking note for a person I already danced with as they don't matter anymore")

### Changed
- **Present Tab Display Logic**: Hide general notes and ranking reasons for dancers already danced with
- **Conditional Information Display**: Pre-event notes and ranking reasons only shown for dancers not yet danced with in Present tab

### Improved
- **Cleaner Present Tab**: Focus on relevant information - once danced, only show "Danced!" indicator with impression
- **Better UX**: Removes cognitive load from irrelevant pre-event information after dancing
- **Context-Aware Display**: Planning tab still shows all information for planning purposes

### Technical
- Updated `lib/widgets/dancer_card.dart` with conditional logic for notes and ranking reasons display
- Added `(isPlanningMode || !dancer.hasDanced)` condition for both general notes and ranking reasons
- Maintains full information display in Planning mode while streamlining Present mode for post-dance experience

---

## [v0.16.0] - 2025-06-29

### User Requests
- "continue" (from Next steps: "update the workflow rule - include the spec update and next steps update in the commit")

### Improved
- **Enhanced Workflow Rule**: Updated development workflow to explicitly include Implementation specification.md and Next steps.md updates in commit process
- **Better Documentation Sync**: More structured approach to keeping all documentation files synchronized
- **Cleaner Process**: Explicit steps for specification updates and next steps cleanup

### Changed
- **Cursor Rules**: Modified the 5-step workflow rule to separate specification updates (step 3) and next steps cleanup (step 4) from commit process (step 5)
- **Commit Process**: Now explicitly includes code changes, changelog, specification updates, and next steps cleanup in single commit

### Technical
- Updated `.cursorrules` file with enhanced workflow rule
- Added explicit steps for Implementation specification.md updates
- Added explicit steps for Next steps.md cleanup
- Improved documentation synchronization process

---

## [v0.15.0] - 2025-06-29

### User Requests
- "continue" (from Next steps: "put the event date into the same line in Event Screen title and skip the year")

### Changed
- **Event Screen Title Format**: Combined event name and date on single line with cleaner format
- **Date Display**: Removed year from event date, showing only month and day (e.g., "Dec 15" instead of "Dec 15, 2024")
- **Title Layout**: Simplified from Column layout to single Text widget for more compact appearance

### Improved
- **Compact Design**: More space-efficient title bar allows for longer event names
- **Cleaner Look**: Single-line format reduces visual clutter and improves readability
- **Better UX**: Current year is implied, showing only essential date information

### Technical
- Updated `lib/screens/event_screen.dart` with simplified AppBar title layout
- Changed DateFormat from 'MMM d, y' to 'MMM d' to exclude year
- Replaced Column widget with single Text widget using string interpolation
- Format: "Event Name - Dec 15" instead of two-line layout

---

## [v0.14.0] - 2025-06-29

### User Requests
- "great, continue with next task" (from Next steps: "show the impression next to the 'Danced' indicator")

### Added
- **Impression Display**: Dance impressions now appear next to the "Danced!" indicator in dancer cards
- **Rich Text Format**: Impressions displayed with italic styling to distinguish from the main "Danced!" text

### Improved
- **Better Context**: Users can now see dance impressions directly in the dancer card without opening dialogs
- **Enhanced Information Display**: Consistent formatting with other dancer information (notes, ranking reasons)
- **User Experience**: Quick access to post-dance feedback and impressions at a glance

### Technical
- Updated `lib/widgets/dancer_card.dart` with RichText widget for combined "Danced!" + impression display
- Used TextSpan for different styling of "Danced!" text vs impression text
- Maintained consistent sizing and padding with other information elements
- Applied dart format for code consistency

---

## [v0.13.0] - 2025-06-29

### User Requests
- "go with next task" (from Next steps: "change 'Edit notes' to 'Edit general note'")

### Changed
- **UI Text Clarity**: Changed "Edit Notes" to "Edit general note" in dancer actions dialog
- **Better Terminology**: More specific text helps distinguish between general dancer notes and event-specific notes/reasons

### Improved
- **User Interface Clarity**: Button text now clearly indicates it edits general dancer information, not event-specific context
- **Consistent Documentation**: Updated both code implementation and wireframes documentation

### Technical
- Updated `lib/widgets/dancer_actions_dialog.dart` with clearer action text
- Updated `Wireframes.md` documentation for consistency
- Applied dart format to maintain code style standards

---

## [v0.12.0] - 2025-06-29

### User Requests
- "implement next step" (from Next steps: "the event screen title should include the event date because I may have many events with same name (recurring events)")

### Added
- **Event Date in Title**: Event Screen now displays both event name and formatted date in the AppBar title
- **Better Event Identification**: Users can now distinguish between recurring events with the same name

### Changed
- **Event Screen AppBar**: Modified title from single text to column layout with event name and date
- **Title Layout**: Event name shown in larger font (20px) with date subtitle in smaller font (14px)

### Improved
- **Recurring Event Support**: Much easier to identify which specific occurrence of a recurring event you're viewing
- **User Experience**: Clear visual hierarchy with event name prominent and date as supporting information

### Technical
- Enhanced `lib/screens/event_screen.dart` with multi-line AppBar title
- Added `intl` package import for DateFormat functionality
- Used `DateFormat('MMM d, y')` for consistent date formatting (e.g., "Dec 15, 2024")
- Implemented Column layout with proper text styling and alignment

---

## [v0.11.0] - 2025-06-29

### User Requests
- "take next item" (from Next steps: "make sure events are sorted by date descending")

### Changed
- **Documentation Updated**: Clarified that events are sorted by date descending (newest first) in Implementation specification

### Improved
- **Specification Accuracy**: Home Screen section now explicitly documents event sorting behavior

### Technical
- Verified existing `OrderingTerm.desc(e.date)` implementation is working correctly
- Updated `Implementation specification.md` Home Screen section with sorting documentation
- No code changes needed - sorting was already implemented properly

---

## [v0.10.0] - 2025-06-29

### User Requests
- "I can't type in the event name field"

### Fixed
- **Event Name Field Input Issue**: Added autofocus, keyboardType, and textInputAction to ensure proper text input functionality
- **TextField Focus**: Event name field now automatically gets focus when Create Event screen opens
- **Keyboard Appearance**: Explicit text input type ensures keyboard appears correctly on all platforms

### Technical
- Enhanced `lib/screens/create_event_screen.dart` with improved TextFormField configuration
- Added `autofocus: true` for automatic field focus
- Added `keyboardType: TextInputType.text` for explicit text input
- Added `textInputAction: TextInputAction.next` for better UX

---

## [v0.9.0] - 2025-06-29

### User Requests
- "Now let's enhance this way of working: keep the commit message concise, add a section in the Changelog to the modified version with a list of my messages to Cursor agent and bump the version right away"
- "Write a Cursor rule that describes this new flow"
- "Nice, please migrate the history from @Next steps.md to @# Changelog"
- "Let's change how we work. After you implement the step add summary to a Changelog.md and commit all the modified files."
- "let's go!" (implementing smart filtering improvements)
- "Let's continue" (continuing with planned next steps)

### Added
- **User Request Tracking**: Changelog now includes "User Requests" section documenting development triggers
- **Immediate Version Bumping**: Each development session gets its own version number
- **Enhanced Workflow Rule**: Updated Cursor rule with concise commits and version management

### Changed
- **Commit Message Style**: Now enforces concise, focused commit messages (1-2 lines max)
- **Version Strategy**: Moved from [Unreleased] accumulation to immediate version bumping per session
- **Changelog Format**: Each version now documents the user requests that drove the development

### Improved
- **Development Traceability**: Clear connection between user requests and implemented changes
- **Workflow Efficiency**: Faster version releases with focused, concise documentation

### Technical
- Updated `.cursorrules` with enhanced workflow including user request tracking and immediate versioning
- Modified changelog standards to support per-session version bumping

---

## [v0.8.0] - Recent Session (Smart Filtering & Focused Workflow)

### Added
- **Smart Filtering for Add Existing Dancer**: Screen now excludes both ranked AND already present dancers to prevent duplicates
- **Enhanced Service Layer**: Updated `getUnrankedDancersForEvent` to filter out present dancers from attendances table
- **Smart Empty States**: Planning tab differentiates between no dancers added vs all dancers present

### Changed
- **Planning Tab Focus**: Now only shows ranked dancers who are NOT present yet, creating focused checklist for event attendance
- **Efficient Presence Workflow**: Planning tab becomes streamlined presence-tracking tool during events
- **UI Text Updates**: All related messaging updated to reflect "unranked AND absent" filtering scope

### Improved
- **Better UX**: Clear guidance on when to switch between Planning and Present tabs
- **Duplicate Prevention**: Dancers disappear from appropriate lists once marked present
- **Improved Efficiency**: Users only see truly available dancers for marking present

---

## [v0.7.0] - Dual FAB Actions & Enhanced Present Tab

### Added
- **Dual FAB Actions for Present Tab**: Add existing dancers to Present tab who weren't in planning
- **New AddExistingDancerScreen**: For unranked dancers appearing at events
- **Enhanced FAB Menu**: Present tab FAB shows modal with "Add New Dancer" and "Add Existing Dancer" options

### Improved
- **Focused Scope**: Shows only unranked dancers (ranked dancers managed via Planning tab)
- **Simple UX**: One-tap to mark dancer as present with immediate action buttons
- **Context Display**: Shows dancer notes to help with identification
- **Clear Guidance**: Info banner explains scope and directs users to Planning tab for ranked dancers

---

## [v0.6.0] - Enhanced Dancer Card Display

### Added
- **Enhanced Information Display**: DancerCard widget now shows both personal notes and event-specific ranking reasons
- **Visual Enhancement**: Added distinct icons (note_outlined for personal notes, psychology_outlined for ranking reasons)

### Improved
- **Better UX**: Each piece of information has proper styling and color coding for easy distinction
- **Complete Context**: Users now see full dancer context including personal notes and event-specific ranking reasoning

---

## [v0.5.0] - Development Workflow Enhancement

### Added
- **Comprehensive Cursor Configuration**: Enhanced .cursorrules with const expression rules, task focus rules
- **Auto-run Mode**: Flutter analyze and dart format now execute automatically without approval dialogs
- **Stricter Linting**: Enhanced analysis_options.yaml with 20+ additional lint rules for code quality
- **Development Scripts**: Created scripts/analyze.sh for quick code quality checks
- **Auto-formatting**: Set up dart format integration and VS Code settings

### Technical Rules Added
- Never use `const` with dynamic values (Theme.of(context), context.danceTheme)
- Stay focused on current task - no unrelated changes
- Auto-format all modified Dart files
- Handle linter errors efficiently (max 3 iterations per file)

---

## [v0.4.0] - Material 3 Theme System

### Added
- **Comprehensive Theme System**: Complete Material 3 theme with custom extensions
- **Theme Foundation**: Proper color schemes (light/dark), semantic colors, and dance-specific extensions
- **Theme Files**: `app_theme.dart`, `color_schemes.dart`, `theme_extensions.dart`

### Changed
- **Migrated All Hardcoded Colors**: Entire app now uses theme system consistently

---

## [v0.3.0] - Reactive Architecture Migration

### Added
- **Reactive Streams Architecture**: Converted to Drift database observation with StreamBuilder
- **Automatic UI Refresh**: UI now automatically refreshes for ALL data changes (notes, rankings, attendance, etc.)

### Changed
- **Major Architecture Improvement**: Replaced manual callback chains with watchDancersForEvent() streams
- **Real-time Updates**: List refreshes automatically when dancers are marked absent/present

### Fixed
- **Planning Tab Refresh Issue**: Marking dancer as absent now properly refreshes the list

---

## [v0.2.0] - Combo Actions

### Added
- **Mark Present & Record Dance**: Combo action for absent dancers in Present tab
- **Streamlined Workflow**: Single action to mark presence and record dance completion

### Improved
- **Efficient Event Management**: Reduced steps for common event workflows

---

## Development Notes

### Recent Improvements (Latest Session)
1. **Planning Tab Optimization**: Converted from showing all ranked dancers to only showing absent ranked dancers, making it perfect for event attendance tracking
2. **Smart Filtering Enhancement**: Add Existing Dancer dialog now intelligently excludes present dancers, preventing duplicate attendance records
3. **Documentation Sync**: All specifications updated to match implementation changes 