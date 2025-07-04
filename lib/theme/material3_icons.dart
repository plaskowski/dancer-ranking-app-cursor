import 'package:flutter/material.dart';

/// Material 3 Icons Guide and Examples
///
/// This file demonstrates how to use Material 3 icons in the Dancer Ranking App.
/// Material 3 introduces new icon variants and improved iconography.

class Material3IconsGuide {
  /// Material 3 Icon Variants
  ///
  /// Material 3 introduces different icon variants:
  /// - Filled: Icons.icon_name (default)
  /// - Outlined: Icons.icon_name_outlined
  /// - Rounded: Icons.icon_name_rounded
  /// - Sharp: Icons.icon_name_sharp
  /// - Two-tone: Icons.icon_name_two_tone

  /// Common Material 3 Icons for the Dancer Ranking App
  static const Map<String, IconData> commonIcons = {
    // Navigation
    'home': Icons.home,
    'home_outlined': Icons.home_outlined,
    'people': Icons.people,
    'people_outlined': Icons.people_outlined,
    'settings': Icons.settings,
    'settings_outlined': Icons.settings_outlined,

    // Actions
    'add': Icons.add,
    'add_outlined': Icons.add_outlined,
    'edit': Icons.edit,
    'edit_outlined': Icons.edit_outlined,
    'delete': Icons.delete,
    'delete_outlined': Icons.delete_outlined,
    'close': Icons.close,
    'close_outlined': Icons.close_outlined,
    'check': Icons.check,
    'check_outlined': Icons.check_outlined,

    // Dance-specific
    'music_note': Icons.music_note,
    'music_note_outlined': Icons.music_note_outlined,
    'event': Icons.event,
    'event_outlined': Icons.event_outlined,
    'calendar_today': Icons.calendar_today,
    'calendar_today_outlined': Icons.calendar_today_outlined,

    // Status
    'archive': Icons.archive,
    'archive_outlined': Icons.archive_outlined,
    'restore': Icons.restore,
    'restore_outlined': Icons.restore_outlined,
    'history': Icons.history,
    'history_outlined': Icons.history_outlined,

    // Feedback
    'error': Icons.error,
    'error_outline': Icons.error_outline,
    'warning': Icons.warning,
    'warning_amber': Icons.warning_amber,
    'info': Icons.info,
    'info_outline': Icons.info_outline,
    'check_circle': Icons.check_circle,
    'check_circle_outline': Icons.check_circle_outline,
  };

  /// Get Material 3 icon with proper styling
  static Icon getMaterial3Icon(
    IconData iconData, {
    Color? color,
    double? size,
    bool outlined = false,
  }) {
    return Icon(
      iconData,
      color: color,
      size: size,
    );
  }

  /// Get outlined variant of an icon
  static IconData getOutlinedVariant(IconData filledIcon) {
    // This is a helper method - in practice, you'd use the specific outlined icon
    // For example: Icons.edit -> Icons.edit_outlined
    return filledIcon;
  }
}

/// Material 3 Icon Usage Examples
class Material3IconExamples {
  /// Example: Navigation Icons with Material 3 styling
  static Widget navigationIconsExample(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Filled variant (default)
        Icon(
          Icons.home,
          color: Theme.of(context).colorScheme.primary,
          size: 24,
        ),
        // Outlined variant
        Icon(
          Icons.home_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 24,
        ),
        // Rounded variant
        Icon(
          Icons.home_rounded,
          color: Theme.of(context).colorScheme.secondary,
          size: 24,
        ),
      ],
    );
  }

  /// Example: Action Icons with Material 3 styling
  static Widget actionIconsExample(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Add action
        Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.primary,
        ),
        // Edit action
        Icon(
          Icons.edit_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        // Delete action
        Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.error,
        ),
      ],
    );
  }

  /// Example: Status Icons with Material 3 styling
  static Widget statusIconsExample(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Success
        Icon(
          Icons.check_circle,
          color: Theme.of(context).colorScheme.primary,
        ),
        // Warning
        Icon(
          Icons.warning_amber,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        // Error
        Icon(
          Icons.error_outline,
          color: Theme.of(context).colorScheme.error,
        ),
        // Info
        Icon(
          Icons.info_outline,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  /// Example: Dance-specific Icons with Material 3 styling
  static Widget danceIconsExample(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Music note
        Icon(
          Icons.music_note,
          color: Theme.of(context).colorScheme.primary,
        ),
        // Event
        Icon(
          Icons.event_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        // Calendar
        Icon(
          Icons.calendar_today_outlined,
          color: Theme.of(context).colorScheme.secondary,
        ),
        // People
        Icon(
          Icons.people_outlined,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ],
    );
  }
}

/// Material 3 Icon Best Practices
class Material3IconBestPractices {
  /// Use consistent icon variants throughout the app
  ///
  /// Guidelines:
  /// - Use filled icons for primary actions and selected states
  /// - Use outlined icons for secondary actions and unselected states
  /// - Use rounded icons for a softer, more friendly appearance
  /// - Use sharp icons for a more geometric, modern appearance

  /// Color Guidelines:
  /// - Primary actions: colorScheme.primary
  /// - Secondary actions: colorScheme.onSurfaceVariant
  /// - Destructive actions: colorScheme.error
  /// - Success states: colorScheme.primary
  /// - Warning states: colorScheme.tertiary
  /// - Info states: colorScheme.onSurfaceVariant

  /// Size Guidelines:
  /// - Standard: 24.0 (default)
  /// - Small: 18.0
  /// - Large: 32.0
  /// - Extra large: 48.0 (for empty states)
}
