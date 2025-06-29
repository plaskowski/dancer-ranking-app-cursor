# Next Steps

> **Note**: All completed improvements have been migrated to [Changelog.md](./Changelog.md)
> 
> **Future Roadmap**: Comprehensive feature plans are documented in [Roadmap.md](./Roadmap.md)

## Immediate Next Steps

- add a structured action log to every action, printed to console, so that I can review what exact actions led to a bug
  - print all list items that got rendered (some short info including ID)
  - use format that will be easy to process by Cursor agent
- ...

> **See [Roadmap.md](./Roadmap.md)** for the complete feature roadmap organized by timeline and priority.

## Known Bugs

1. **Date Change Bug** (v0.29.0)
   - Context menu "Change Date" action shows date picker and success message
   - However, the selected date doesn't persist to database
   - UI refreshes but shows original date
   - Needs investigation of EventService.updateEvent method and DateTime handling
   - Suspected issue: DateTime comparison or Drift ORM update mechanism

## Development Process

> **All development follows the rules defined in cursor_rules for this repository**

### Workflow
1. Implement improvement with proper error handling
2. Update Changelog.md with version bump and user request documentation
3. Update Implementation specification.md if behavior changes
4. Clean up Next steps.md by removing completed tasks
5. Commit changes with conventional commit format
6. Test functionality before marking as complete
