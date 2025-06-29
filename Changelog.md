# Changelog

All notable changes to the Dancer Ranking App will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- **Smart Empty States**: Planning tab now shows different messages based on whether no dancers are added vs all dancers are present
- **Enhanced Filtering**: Add Existing Dancer screen now excludes both ranked AND already present dancers to prevent duplicates

### Changed
- **Planning Tab Focus**: Now only shows ranked dancers who are NOT present yet, creating a focused checklist for event attendance
- **Add Existing Dancer Scope**: Updated to show "unranked AND absent dancers only" with clearer messaging
- **Service Layer Enhancement**: Updated `getUnrankedDancersForEvent()` to filter out present dancers from attendances table
- **UI Text Updates**: All related UI text updated to reflect new filtering behavior

### Improved
- **Event Workflow Efficiency**: Planning tab becomes a streamlined presence-tracking tool during events
- **Duplicate Prevention**: Dancers disappear from appropriate lists once marked present, eliminating confusion
- **User Experience**: Clear guidance on when to switch between Planning and Present tabs
- **Data Consistency**: Better separation of concerns between tabs with focused functionality

### Technical
- Enhanced `lib/services/dancer_service.dart` with dual filtering logic
- Updated `lib/screens/tabs/planning_tab.dart` with presence filtering and smart empty states
- Modified `lib/screens/add_existing_dancer_screen.dart` with enhanced availability filtering
- Updated `Implementation specification.md` to reflect new behavior
- Added theme extension import for success color usage

---

## Development Notes

### Recent Improvements (Latest Session)
1. **Planning Tab Optimization**: Converted from showing all ranked dancers to only showing absent ranked dancers, making it perfect for event attendance tracking
2. **Smart Filtering Enhancement**: Add Existing Dancer dialog now intelligently excludes present dancers, preventing duplicate attendance records
3. **Documentation Sync**: All specifications updated to match implementation changes 