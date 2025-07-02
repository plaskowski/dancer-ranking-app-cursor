import 'package:flutter/material.dart';

/// Utility class for determining event status based on dates
/// This centralizes the logic used in EventScreen for tab visibility
/// and allows reuse for styling current events in other screens
class EventStatusHelper {
  /// Checks if an event is in the past (before today)
  static bool isPastEvent(DateTime eventDate) {
    return eventDate.isBefore(DateUtils.dateOnly(DateTime.now()));
  }

  /// Checks if an event is "old" (2+ days ago)
  /// Old events only show the Summary tab in EventScreen
  static bool isOldEvent(DateTime eventDate) {
    return eventDate.isBefore(DateTime.now().subtract(const Duration(days: 2)));
  }

  /// Checks if an event is "current" (not old)
  /// Current events show multiple tabs in EventScreen and should have green dates
  /// This includes: future events, today's events, and events from yesterday/day before
  static bool isCurrentEvent(DateTime eventDate) {
    return !isOldEvent(eventDate);
  }

  /// Gets the appropriate tabs for an event based on its date
  /// Returns the same logic as used in EventScreen
  static List<String> getAvailableTabs(DateTime eventDate) {
    if (isOldEvent(eventDate)) {
      return ['summary']; // Old events only have Summary tab
    } else if (isPastEvent(eventDate)) {
      return ['present', 'summary']; // Past events have Present and Summary
    } else {
      return ['planning', 'present', 'summary']; // Future events have all tabs
    }
  }
}
