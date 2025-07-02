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

  /// Checks if an event is far in the future (1+ days from now)
  /// Far future events only show the Planning tab in EventScreen
  static bool isFarFutureEvent(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final tomorrow = today.add(const Duration(days: 1));
    final eventOnly = DateUtils.dateOnly(eventDate);

    return eventOnly.isAfter(tomorrow) || eventOnly.isAtSameMomentAs(tomorrow);
  }

  /// Checks if an event is "current" for green date marking
  /// Current events are within a reasonable timeframe (recent or soon)
  /// This includes events from 2 days ago through 3 days in the future
  static bool isCurrentEvent(DateTime eventDate) {
    final now = DateTime.now();
    final today = DateUtils.dateOnly(now);
    final eventOnly = DateUtils.dateOnly(eventDate);

    // Events from 2 days ago through 3 days in the future are "current"
    final earliestCurrent = today.subtract(const Duration(days: 2));
    final latestCurrent = today.add(const Duration(days: 3));

    return !eventOnly.isBefore(earliestCurrent) && !eventOnly.isAfter(latestCurrent);
  }

  /// Checks if an event has multiple tabs (not old)
  /// This is the original logic for tab visibility in EventScreen
  static bool hasMultipleTabs(DateTime eventDate) {
    return !isOldEvent(eventDate);
  }

  /// Gets the appropriate tabs for an event based on its date
  /// Returns the same logic as used in EventScreen
  static List<String> getAvailableTabs(DateTime eventDate) {
    if (isOldEvent(eventDate)) {
      return ['summary']; // Old events only have Summary tab
    } else if (isFarFutureEvent(eventDate)) {
      return ['planning']; // Far future events (1+ days) only have Planning tab
    } else if (isPastEvent(eventDate)) {
      return ['present', 'summary']; // Past events have Present and Summary
    } else {
      return ['planning', 'present', 'summary']; // Current events have all tabs
    }
  }
}
