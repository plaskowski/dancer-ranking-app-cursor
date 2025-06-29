# Next Steps

> **Note**: All completed improvements have been migrated to [Changelog.md](./Changelog.md)

## Upcoming Improvements

### Near-term (next few weeks)

1. **Advanced Features**
   - Multiple evaluation criteria (technique, musicality, stage presence)
   - Weighted scoring system
   - Batch operations for multiple dancers
   - Export functionality (CSV, PDF reports)

2. **User Experience**
   - Search and filter functionality for dancers/events
   - Bulk import from CSV
   - Dark mode support
   - Improved offline functionality

3. **Data Management**
   - Data backup and restore
   - Event templates
   - Historical data analysis and trends
   - Archive old events

### Future Enhancements

1. **Collaboration Features**
   - Multi-judge support with role-based access
   - Judge consensus tracking
   - Comment system for evaluations

2. **Analytics and Reporting**
   - Detailed performance analytics
   - Progress tracking over time
   - Comparative analysis between events
   - Statistical insights

3. **Platform Expansion**
   - Web version for desktop use
   - Cloud synchronization
   - Integration with external dance systems

4. **Advanced Functionality**
   - Video recording integration
   - Photo attachments for dancers
   - Custom evaluation forms
   - Tournament bracket generation

## Known Bugs

1. **Date Change Bug** (v0.29.0)
   - Context menu "Change Date" action shows date picker and success message
   - However, the selected date doesn't persist to database
   - UI refreshes but shows original date
   - Needs investigation of EventService.updateEvent method and DateTime handling
   - Suspected issue: DateTime comparison or Drift ORM update mechanism

## Recently Completed

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
