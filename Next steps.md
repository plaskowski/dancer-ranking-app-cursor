# Next Steps

> **Note**: All completed improvements have been migrated to [Changelog.md](./Changelog.md)

- add a structured action log to every action, printed to console, so that I can review what exact actions led to a bug
  - print all list items that got rendered (some short info including ID)
  - use format that will be easy to process by Cursor agent

## Upcoming Improvements

### Near-term (next few weeks)

1. **Search & Filter Features**
   - Search functionality for dancers by name and notes
   - Filter events by date range (past/upcoming)
   - Quick filter buttons (present/absent, danced/not danced)
   - Advanced search with multiple criteria

2. **Advanced Ranking System**
   - Multiple evaluation criteria (technique, musicality, stage presence)
   - Weighted scoring system with customizable weights
   - Ranking templates for different event types
   - Composite scores with detailed breakdowns

3. **Batch Operations**
   - Select multiple dancers for bulk actions
   - Bulk rank assignment
   - Bulk presence marking
   - Mass export/import operations

4. **Export & Reporting**
   - CSV export for events and dancer data
   - PDF reports with event summaries
   - Performance analytics reports
   - Custom report templates

### Medium-term (next few months)

1. **User Experience Enhancements**
   - Dark mode support with theme switching
   - Bulk import from CSV files
   - Event templates for recurring event types
   - Improved offline functionality and sync
   - Animation improvements and smooth transitions
   - Better loading states and progress indicators

2. **Data Management**
   - Data backup and restore functionality
   - Archive system for old events
   - Event duplication/cloning
   - Data cleanup and optimization tools
   - Import/export between different formats

3. **Analytics and Insights**
   - Performance tracking over time
   - Dancer progress analytics
   - Event comparison tools
   - Statistical insights and trends
   - Personalized recommendations

### Future Enhancements

1. **Collaboration Features**
   - Multi-judge support with role-based access
   - Judge consensus tracking and conflict resolution
   - Comment system for evaluations
   - Real-time collaboration during events

2. **Advanced Functionality**
   - Video recording integration
   - Photo attachments for dancers
   - Custom evaluation forms and criteria
   - Tournament bracket generation
   - Integration with external dance systems

3. **Platform Expansion**
   - Web version for desktop use
   - Cloud synchronization across devices
   - Mobile responsiveness improvements
   - Cross-platform data sharing

4. **Polish & Performance**
   - Enhanced error handling and recovery
   - Performance optimizations for large datasets
   - Accessibility improvements
   - Internationalization support

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
1. Implement the improvement
2. Update the changelog with a clear summary  
3. Commit all changes with descriptive messages
4. Keep documentation synchronized
