# Next Steps

## Immediate Priorities (take one at a time)
- need both impressionTag and impression text
- importable format (person, tags, notes)
- predefined impressions
- ...
- parse events
  - provide agent an example so they understand the structure

## Little later
- tap tag pill to filter the list by that tag

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
