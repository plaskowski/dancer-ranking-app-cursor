# Material 3 Icons Guide

## Overview

Material 3 introduces enhanced iconography with multiple variants and improved visual consistency. This guide shows how to properly implement Material 3 icons in the Dancer Ranking App.

## Icon Variants

Material 3 provides several icon variants:

### 1. **Filled Icons** (Default)
- Use for primary actions and selected states
- Example: `Icons.edit`, `Icons.add`, `Icons.home`

### 2. **Outlined Icons** 
- Use for secondary actions and unselected states
- Example: `Icons.edit_outlined`, `Icons.add_outlined`, `Icons.home_outlined`

### 3. **Rounded Icons**
- Use for a softer, more friendly appearance
- Example: `Icons.edit_rounded`, `Icons.add_rounded`

### 4. **Sharp Icons**
- Use for a more geometric, modern appearance
- Example: `Icons.edit_sharp`, `Icons.add_sharp`

### 5. **Two-tone Icons**
- Use for special emphasis or decorative purposes
- Example: `Icons.edit_two_tone`, `Icons.add_two_tone`

## Color Guidelines

### Primary Actions
```dart
Icon(
  Icons.edit_outlined,
  color: Theme.of(context).colorScheme.primary,
)
```

### Secondary Actions
```dart
Icon(
  Icons.settings_outlined,
  color: Theme.of(context).colorScheme.onSurfaceVariant,
)
```

### Destructive Actions
```dart
Icon(
  Icons.delete_outline,
  color: Theme.of(context).colorScheme.error,
)
```

### Success States
```dart
Icon(
  Icons.check_circle,
  color: Theme.of(context).colorScheme.primary,
)
```

### Warning States
```dart
Icon(
  Icons.warning_amber,
  color: Theme.of(context).colorScheme.tertiary,
)
```

### Info States
```dart
Icon(
  Icons.info_outline,
  color: Theme.of(context).colorScheme.onSurfaceVariant,
)
```

## Size Guidelines

### Standard Size (24.0)
```dart
Icon(Icons.edit_outlined) // Default size
```

### Small Size (18.0)
```dart
Icon(Icons.edit_outlined, size: 18.0)
```

### Large Size (32.0)
```dart
Icon(Icons.edit_outlined, size: 32.0)
```

### Extra Large Size (48.0)
```dart
Icon(Icons.edit_outlined, size: 48.0) // For empty states
```

## Common Icons for Dancer Ranking App

### Navigation
- `Icons.home` / `Icons.home_outlined`
- `Icons.people` / `Icons.people_outlined`
- `Icons.settings` / `Icons.settings_outlined`

### Actions
- `Icons.add` / `Icons.add_outlined`
- `Icons.edit` / `Icons.edit_outlined`
- `Icons.delete` / `Icons.delete_outline`
- `Icons.close` / `Icons.close_outlined`
- `Icons.check` / `Icons.check_outlined`

### Dance-specific
- `Icons.music_note` / `Icons.music_note_outlined`
- `Icons.event` / `Icons.event_outlined`
- `Icons.calendar_today` / `Icons.calendar_today_outlined`

### Status
- `Icons.archive` / `Icons.archive_outlined`
- `Icons.restore` / `Icons.restore_outlined`
- `Icons.history` / `Icons.history_outlined`

### Feedback
- `Icons.error` / `Icons.error_outline`
- `Icons.warning` / `Icons.warning_amber`
- `Icons.info` / `Icons.info_outline`
- `Icons.check_circle` / `Icons.check_circle_outline`

## Best Practices

### 1. **Consistency**
- Use the same icon variant throughout similar contexts
- Maintain consistent color schemes for similar actions

### 2. **Accessibility**
- Ensure sufficient contrast between icon and background
- Use semantic colors from the theme

### 3. **Context**
- Use filled icons for primary/selected states
- Use outlined icons for secondary/unselected states
- Use appropriate colors for different action types

### 4. **Performance**
- Icons are vector graphics and scale well
- No need to worry about different sizes for different screen densities

## Implementation Examples

### Navigation Icons
```dart
// App Bar Actions
IconButton(
  icon: const Icon(Icons.people_outlined),
  onPressed: () => navigateToDancers(),
)

// Bottom Navigation
Icon(Icons.home_outlined, color: isSelected ? primary : onSurfaceVariant)
```

### Action Icons
```dart
// Primary Action
FloatingActionButton(
  child: const Icon(Icons.add),
  onPressed: () => createNew(),
)

// Secondary Action
IconButton(
  icon: const Icon(Icons.edit_outlined),
  onPressed: () => editItem(),
)
```

### Status Icons
```dart
// Success
Icon(Icons.check_circle, color: colorScheme.primary)

// Warning
Icon(Icons.warning_amber, color: colorScheme.tertiary)

// Error
Icon(Icons.error_outline, color: colorScheme.error)
```

## Migration from Material 2

When updating existing icons to Material 3:

1. **Replace filled icons with outlined variants** for secondary actions
2. **Keep filled icons** for primary actions and selected states
3. **Update colors** to use `colorScheme` instead of hardcoded colors
4. **Maintain consistency** across similar UI elements

## Code Examples

### Before (Material 2 style)
```dart
Icon(Icons.edit, color: Colors.blue)
Icon(Icons.delete, color: Colors.red)
Icon(Icons.settings, color: Colors.grey)
```

### After (Material 3 style)
```dart
Icon(Icons.edit_outlined, color: Theme.of(context).colorScheme.primary)
Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error)
Icon(Icons.settings_outlined, color: Theme.of(context).colorScheme.onSurfaceVariant)
```

## Resources

- [Material Design Icons](https://fonts.google.com/icons)
- [Material 3 Design System](https://m3.material.io/)
- [Flutter Icons Documentation](https://api.flutter.dev/flutter/material/Icons-class.html) 