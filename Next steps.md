# Next Steps

> **Note**: All completed improvements have been migrated to [Changelog.md](./Changelog.md)

## Upcoming Improvements

### Tab Vertical Space Issue - 3 UX Approaches:

**Approach 1: Bottom Navigation Tabs** 🏆 *Recommended*
- Move tabs from AppBar to bottom of screen as BottomNavigationBar
- **Pros**: Thumb-friendly, saves significant header space, follows mobile UX patterns
- **Cons**: Takes bottom space (but more accessible than top)
- **Implementation**: Replace TabBar with BottomNavigationBar, move FAB to each tab's content area

**Approach 2: Compact Floating Tab Indicator**
- Replace full TabBar with minimal floating tab indicator (like page dots)
- **Pros**: Maximum space savings, clean minimal design
- **Cons**: Less discoverable, relies heavily on swipe gestures
- **Implementation**: Custom indicator widget, gesture-first navigation

**Approach 3: Integrated Header Tabs**
- Merge event title and tabs into single compact row
- **Pros**: Saves moderate space while keeping familiar pattern
- **Cons**: May feel cramped, less space for event title
- **Implementation**: Custom header with inline tabs, smaller text sizes

**Vote for preferred approach to implement?**

- TODO: Add more improvements here...

## Development Process
1. Implement the improvement
2. Update the changelog with a clear summary  
3. Commit all changes with descriptive messages
4. Keep documentation synchronized
