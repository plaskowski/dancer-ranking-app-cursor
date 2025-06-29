# Next Steps

> **Note**: All completed improvements have been migrated to [Changelog.md](./Changelog.md)
> 
> **Future Roadmap**: Comprehensive feature plans are documented in [Roadmap.md](./Roadmap.md)

## Immediate Next Steps

Based on the current app state and user feedback, the most logical next improvements would be:

### Priority 1: User Experience Polish
- Fix the **Date Change Bug** (context menu date picker doesn't persist)
- Add basic search functionality for dancers by name
- Improve loading states and error handling

### Priority 2: Core Features
- Implement simple filtering (show/hide dancers who left)
- Add bulk operations for common tasks
- Export basic event summaries

### Priority 3: Data Management
- Basic backup/restore functionality
- Event templates for recurring events

> **See [Roadmap.md](./Roadmap.md)** for the complete feature roadmap organized by timeline and priority.

## Known Bugs

### Date Change Bug (Medium Priority)
- **Issue**: Context menu "Change Date" action shows date picker but changes don't persist to database
- **Location**: `home_screen.dart` event context menu → `event_service.dart` updateEvent method
- **Status**: Database update appears to execute but EventsScreen doesn't reflect changes
- **Investigation needed**: EventService update method vs database update mechanism
- **Workaround**: Rename event works fine, suggests service layer issue rather than UI
- **Debug info**: Added logging shows update calls completing but no visible changes
- **Next steps**: Review Drift ORM update patterns and DateTime handling in database layer
- **Suspected issue**: DateTime comparison or Drift ORM update mechanism

## Recently Completed

### Structured Action Logging System (v0.31.0)
- ✅ Comprehensive action logging throughout the app for debugging
- ✅ List rendering logs with item IDs and key properties
- ✅ Service-level database operation tracking
- ✅ User interaction and navigation event logging
- ✅ Cursor agent friendly format for automated analysis

### Context Menu Implementation (v0.30.0)
- ✅ Renamed "Remove from Present" to "Mark absent" for clearer terminology
- ✅ Hide "Remove from event" action in Present tab for better workflow separation
- ✅ Tab-specific context menus with appropriate actions only

### Context Menu Implementation (v0.29.0)
- ✅ Long press context menu on event cards
- ✅ Rename event functionality
- ✅ Delete event with confirmation
- ✅ Change date UI (buggy database update)

## Development Process

This project follows strict version control and documentation practices:
- Each improvement gets a version bump with detailed changelog
- All user requests are documented and referenced
- Implementation details are tracked in technical sections
- Next steps are maintained and cleaned up after completion
