# Next Steps

## Immediate Priorities
- check that on all dancers list they are sorted by name ascending (ofc first sort by rank if the list groups them by it)

### Bug Fixes
- **Event Date Change**: Context menu date picker shows but changes don't persist to database
  - Location: `lib/screens/home_screen.dart` - `_performDateChange` method
  - Issue: Date update operation completes but data doesn't save properly
  - Priority: Medium

### User Experience Improvements  
- **Enhanced Visual Feedback**: Improve loading states and success confirmations across dialogs
- **Accessibility**: Add proper semantic labels and screen reader support
- **Performance**: Optimize database queries and reduce rebuild frequency

### Data Management
- **Data Export**: Add ability to export event data and dancer rankings
- **Backup/Restore**: Implement data backup and restore functionality
- **Data Validation**: Enhanced input validation and error prevention

## Development Infrastructure
- **Testing**: Add unit tests for service methods and widget tests for UI components
- **Error Monitoring**: Implement crash reporting and error analytics
- **Code Quality**: Set up automated code analysis and formatting checks

See `Roadmap.md` for comprehensive future plans and feature roadmap.
