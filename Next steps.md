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

1. **Date Change Bug** (v0.29.0)
   - Context menu "Change Date" action shows date picker and success message
   - However, the selected date doesn't persist to database
   - UI refreshes but shows original date
   - Needs investigation of EventService.updateEvent method and DateTime handling
   - Suspected issue: DateTime comparison or Drift ORM update mechanism

## Recently Completed

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

> **All development follows the rules defined in cursor_rules for this repository**

### Workflow
1. Implement improvement with proper error handling
2. Update Changelog.md with version bump and user request documentation
3. Update Implementation specification.md if behavior changes
4. Clean up Next steps.md by removing completed tasks
5. Commit changes with conventional commit format
6. Test functionality before marking as complete
