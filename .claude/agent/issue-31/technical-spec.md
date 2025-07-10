# Technical Specification: Scroll-to-Bottom Feature for Dancer List

## Overview

This feature adds a scroll-to-bottom floating action button (FAB) to the dancer list screen. The FAB appears when users scroll up from the bottom and provides smooth animation to jump to the list's end.

## Architecture & Implementation Approach

### Core Components

1. **ScrollController Integration**: Add scroll position tracking to detect when user scrolls away from bottom
2. **FAB State Management**: Show/hide logic based on scroll position
3. **Animation Controller**: Smooth scroll animation to bottom
4. **UI Layout**: Multi-FAB layout with proper positioning

### Affected Files

#### Primary Changes

**`lib/screens/event/dialogs/base_dancer_selection_screen.dart`**
- Location: `_DancerListFilterWidget` class (lines 177-502)
- Changes: Add `ScrollController`, scroll position tracking, and scroll-to-bottom FAB
- Impact: Core list rendering logic

**`lib/screens/dancers/dancers_screen.dart`** 
- Location: `DancersScreen` class (lines 17-168)
- Changes: Update `floatingActionButton` to support multiple FABs
- Impact: Main dancers screen layout

#### Supporting Changes

**`lib/widgets/safe_fab.dart`**
- May need updates to support multiple FABs or create new multi-FAB widget
- Review existing implementation for reuse patterns

## Detailed Implementation Plan

### 1. ScrollController Integration

```dart
class _DancerListFilterWidgetState extends State<_DancerListFilterWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottomFAB = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }
  
  void _handleScroll() {
    final isAtBottom = _scrollController.position.pixels >= 
        _scrollController.position.maxScrollExtent - 100; // 100px threshold
    
    if (_showScrollToBottomFAB && isAtBottom) {
      setState(() => _showScrollToBottomFAB = false);
    } else if (!_showScrollToBottomFAB && !isAtBottom) {
      setState(() => _showScrollToBottomFAB = true);
    }
  }
}
```

### 2. ListView Controller Assignment

**Target**: Line 399 in `_DancerListFilterWidget.build()`
```dart
// Current
child: ListView(
  padding: EdgeInsets.zero,
  children: [
    // ... existing content
  ],
),

// Updated
child: ListView(
  controller: _scrollController,
  padding: EdgeInsets.zero,
  children: [
    // ... existing content
  ],
),
```

### 3. Scroll-to-Bottom Method

```dart
void _scrollToBottom() {
  if (_scrollController.hasClients) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
```

### 4. Multi-FAB Widget

**New Component**: `MultiFABWidget` or update existing `SafeFAB`

```dart
class MultiFABLayout extends StatelessWidget {
  final Widget primaryFAB;
  final Widget? secondaryFAB;
  final bool showSecondary;
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showSecondary && secondaryFAB != null) ...[
          secondaryFAB!,
          const SizedBox(height: 16),
        ],
        primaryFAB,
      ],
    );
  }
}
```

### 5. FAB Integration in DancersScreen

**Target**: Lines 162-166 in `DancersScreen.build()`
```dart
// Current
floatingActionButton: SafeFAB(
  onPressed: _showAddDancerDialog,
  child: const Icon(Icons.add),
),

// Updated
floatingActionButton: MultiFABLayout(
  primaryFAB: SafeFAB(
    onPressed: _showAddDancerDialog,
    child: const Icon(Icons.add),
  ),
  secondaryFAB: AnimatedScale(
    scale: _showScrollToBottomFAB ? 1.0 : 0.0,
    duration: const Duration(milliseconds: 200),
    child: SafeFAB(
      onPressed: _scrollToBottom,
      child: const Icon(Icons.keyboard_arrow_down),
    ),
  ),
  showSecondary: _showScrollToBottomFAB,
),
```

## Data Flow & Logic

### Scroll Position Tracking
1. `ScrollController` attached to `ListView` in `_DancerListFilterWidget`
2. `_handleScroll()` method monitors scroll position
3. When user scrolls up > 100px from bottom, show FAB
4. When user reaches bottom again, hide FAB

### State Communication
- `_DancerListFilterWidget` exposes scroll state via callback
- `DancersScreen` receives scroll state updates
- `MultiFABLayout` renders FABs based on state

### Animation Flow
1. User taps scroll-to-bottom FAB
2. `_scrollToBottom()` method called
3. `ScrollController.animateTo()` smoothly scrolls to bottom
4. FAB automatically hides when bottom is reached

## Performance Considerations

### Scroll Listener Optimization
- Use 100px threshold to avoid excessive state updates
- Debounce scroll events if needed for performance
- Dispose `ScrollController` properly in `dispose()`

### Memory Management
```dart
@override
void dispose() {
  _scrollController.removeListener(_handleScroll);
  _scrollController.dispose();
  super.dispose();
}
```

## Testing Strategy

### Widget Tests
- Test FAB visibility based on scroll position
- Test scroll-to-bottom animation
- Test multi-FAB layout rendering

### Integration Tests
- Test with large dancer lists (100+ items)
- Test scroll performance and smoothness
- Test FAB interaction with existing Add Dancer FAB

## Accessibility Considerations

### Semantic Labels
```dart
SafeFAB(
  onPressed: _scrollToBottom,
  child: const Icon(Icons.keyboard_arrow_down),
  tooltip: 'Scroll to bottom',
),
```

### Focus Management
- Ensure FAB is focusable with keyboard navigation
- Proper focus order: Add Dancer FAB → Scroll-to-Bottom FAB

## Out of Scope

### Current Implementation Limitations
- No changes to existing filter/search functionality
- No modifications to dancer card rendering
- No changes to stream-based data loading
- No keyboard shortcuts implementation

### Future Enhancements Not Included
- Scroll-to-top functionality
- Jump to specific alphabet sections
- Custom scroll speeds or easing curves
- Scroll position persistence across screen navigations

## Risk Assessment

### Low Risk
- FAB positioning and visibility logic
- Scroll animation implementation
- Theme integration

### Medium Risk
- Multi-FAB layout complexity
- State management between widgets
- Performance with very large lists (1000+ items)

### Mitigation Strategies
- Thorough testing with various list sizes
- Fallback to standard FAB if multi-FAB fails
- Performance monitoring with large datasets