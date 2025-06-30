# Next Steps

## Immediate Priorities (take one at a time)
- make the toast notification disapear quicker by themselfes and right away when tapped by user
- support an edge case
  - have a rank A
  - set a person rank in an event to A
  - make rank A archived
  - edit person rank in an event to B  <-- currently this fails

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
