# Changelog

All notable changes to the Dancer Ranking App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

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