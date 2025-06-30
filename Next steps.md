# Next Steps

## Immediate Priorities (take one at a time)
- X establish JSON format for event import
  - X I don't want to import event ranking, only dancer presence details
- refine it
  - X event date without time part
  - X I don't have the marked_at and danced_at info, check with the implementation if they can be null
  - in the import preview indicate which tags will be created
  - ImportEventDialog should be in a form of a full screen for more space
- parse events from the diary
  - provide agent an example so they understand the structure
  - decide where to put the overall impression (Bardzo udane, udane, ...) - in future I may want to have separate summary tab

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
