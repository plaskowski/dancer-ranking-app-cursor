# Next Steps

## Immediate Priorities (take one at a time)
- **Test Event Import UI**: Manually test the full-screen Event Import UI and verify the "new dancer" count is accurate.
- **Event Diary Parser**: Parse events from the diary, deciding where to put the overall impression (e.g., "Bardzo udane").
  - Provide agent with an example to understand the structure.

## Little later
- tap tag pill to filter the list by that tag
- try out different models

### Bug Fixes
- **Event Date Change**: Context menu date picker shows but changes don't persist to database
  - Location: `lib/screens/home_screen.dart` - `_performDateChange` method
  - Issue: Date update operation completes but data doesn't save properly
  - Priority: Medium

### Data Management
- **Data Export**: Add ability to export event data and dancer rankings
- **Backup/Restore**: Implement data backup and restore functionality

## Development Infrastructure
- **Testing**: Add unit tests for service methods and widget tests for UI components

See `Roadmap.md` for comprehensive future plans and feature roadmap.
