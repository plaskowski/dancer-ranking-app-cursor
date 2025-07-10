# Functional Specification: Scroll-to-Bottom Feature for Dancer List

## User Story

**As a** user managing a large list of dancers after event imports  
**I want** a quick way to navigate to the bottom of the dancer list  
**So that** I can easily access the most recently added dancers without manual scrolling

## Behavioral Summary

### Current State
- Users must manually scroll through potentially hundreds of dancers to reach the bottom
- This is particularly problematic after event imports when new dancers are added
- No quick navigation options exist for long lists

### Proposed Solution
- Add a floating action button (FAB) that appears when scrolling up from the bottom
- The FAB will have a "scroll to bottom" icon (arrow down or similar)
- Tapping the FAB will smoothly animate the list to the bottom
- The FAB will be positioned to avoid conflicts with the existing "Add Dancer" FAB

## ASCII Wireframe Mockup

```
┌─────────────────────────────────────┐
│ ← Dancers                           │ AppBar
├─────────────────────────────────────┤
│ 🔍 Search + Filter Section          │
├─────────────────────────────────────┤
│ ℹ️ Info: Manage your dancers...     │
├─────────────────────────────────────┤
│ 👤 Dancer Name A                    │
│    Last met: 2 weeks ago            │
├─────────────────────────────────────┤
│ 👤 Dancer Name B                    │
│    Last met: 1 month ago            │
├─────────────────────────────────────┤
│ 👤 Dancer Name C                    │
│    Last met: 3 days ago             │
├─────────────────────────────────────┤
│ ...                                 │
│ (many more dancers)                 │
│ ...                                 │
├─────────────────────────────────────┤
│ 👤 Dancer Name Z                    │
│    Last met: Never                  │
└─────────────────────────────────────┘
                         ⬇️  📝 
                        FAB FAB
                      (scroll)(add)
```

### FAB Behavior
- **Scroll-to-bottom FAB**: Appears when user scrolls up from bottom
- **Add dancer FAB**: Existing functionality (always visible)
- **Positioning**: Scroll FAB positioned above Add FAB to avoid overlap

## UX Patterns Used

### Material Design Patterns
- **Floating Action Button (FAB)**: Primary action pattern for quick navigation
- **Smooth Scrolling Animation**: Standard Material motion for scroll transitions
- **Icon Selection**: Uses Material Icons for consistency (likely `keyboard_arrow_down` or `vertical_align_bottom`)

### Existing App Patterns
- **SafeFAB**: The app already uses a `SafeFAB` wrapper for the Add Dancer button
- **Animation**: The app likely uses Flutter's standard animation controllers
- **Theme Integration**: Will use the app's existing Material 3 theme and color scheme

### Pattern References in Codebase
- `SafeFAB` usage in `DancersScreen` (line 162-166)
- Material 3 theming in `theme/` directory
- Existing scroll behavior in `ListView` implementations

## Acceptance Criteria

1. **Visibility**: Scroll-to-bottom FAB appears when user scrolls up from the bottom of the list
2. **Functionality**: Tapping the FAB smoothly scrolls the list to the bottom
3. **Positioning**: FAB does not interfere with existing Add Dancer FAB
4. **Performance**: Smooth animation without lag on lists with hundreds of items
5. **Accessibility**: FAB has proper semantic labels for screen readers
6. **Consistency**: Uses existing app theming and icon patterns

## Out of Scope

- Scroll-to-top functionality (not requested)
- Keyboard shortcuts for navigation
- Alternative navigation methods (list index, jump to letter)
- Modifications to existing filter or search functionality