import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import 'dancer_event_service.dart';
import 'dancer_models.dart';

enum ActivityLevel {
  all,
  regular,
  occasional,
}

class DancerActivityService {
  final AppDatabase _database;

  DancerActivityService(this._database);

  /// Get dancers filtered by activity level
  Stream<List<DancerWithEventInfo>> watchDancersByActivityLevel(
    int eventId,
    ActivityLevel level,
  ) {
    final dancerEventService = DancerEventService(_database);

    switch (level) {
      case ActivityLevel.all:
        return dancerEventService.watchDancersForEvent(eventId);

      case ActivityLevel.regular:
        return _getActiveDancers(eventId, months: 2, minEvents: 3);

      case ActivityLevel.occasional:
        return _getActiveDancers(eventId, months: 3, minEvents: 1);
    }
  }

  /// Filter dancers based on activity level for general use (not event-specific)
  Stream<List<DancerWithTags>> filterDancersByActivityLevel(
    Stream<List<DancerWithTags>> dancersStream,
    ActivityLevel level,
  ) {
    if (level == ActivityLevel.all) {
      return dancersStream;
    }

    return dancersStream.asyncMap((dancers) async {
      final filteredDancers = <DancerWithTags>[];

      for (final dancer in dancers) {
        final dancerLevel = await getDancerActivityLevel(dancer.id);

        // Check if dancer meets the activity level criteria
        bool includeInResults = false;

        if (level == ActivityLevel.regular) {
          // Regular: Must have 3+ events in last 2 months
          includeInResults = await _isDancerRegular(dancer.id);
        } else if (level == ActivityLevel.occasional) {
          // Occasional: Must have 1+ event in last 3 months
          includeInResults = await _isDancerOccasional(dancer.id);
        }

        if (includeInResults) {
          filteredDancers.add(dancer);
        }
      }

      return filteredDancers;
    });
  }

  Stream<List<DancerWithEventInfo>> _getActiveDancers(
    int eventId, {
    required int months,
    required int minEvents,
  }) {
    final dancerEventService = DancerEventService(_database);

    return dancerEventService.watchDancersForEvent(eventId).asyncMap((dancers) async {
      final filteredDancers = <DancerWithEventInfo>[];

      for (final dancer in dancers) {
        final recentEventCount = await getRecentEventCount(dancer.id, months);
        if (recentEventCount >= minEvents) {
          filteredDancers.add(dancer);
        }
      }

      return filteredDancers;
    });
  }

  /// Check if a dancer is considered "regular" (3+ events in last 2 months)
  Future<bool> _isDancerRegular(int dancerId) async {
    final eventCount = await getRecentEventCount(dancerId, 2);
    return eventCount >= 3;
  }

  /// Check if a dancer is considered "occasional" (1+ event in last 3 months)
  Future<bool> _isDancerOccasional(int dancerId) async {
    final eventCount = await getRecentEventCount(dancerId, 3);
    return eventCount >= 1;
  }

  /// Get count of events dancer attended in the last N months
  Future<int> getRecentEventCount(int dancerId, int months) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: months * 30));

    // Count attendances in recent events
    final query = _database.select(_database.attendances).join([
      innerJoin(_database.events, _database.events.id.equalsExp(_database.attendances.eventId)),
    ])
      ..where(_database.attendances.dancerId.equals(dancerId))
      ..where(_database.events.date.isBiggerThanValue(cutoffDate));

    final results = await query.get();
    return results.length;
  }

  /// Get count of dancers for each activity level
  Future<Map<ActivityLevel, int>> getActivityLevelCounts(int eventId) async {
    final counts = <ActivityLevel, int>{};

    for (final level in ActivityLevel.values) {
      final dancers = await watchDancersByActivityLevel(eventId, level).first;
      counts[level] = dancers.length;
    }

    return counts;
  }

  /// Get activity level for a specific dancer
  Future<ActivityLevel> getDancerActivityLevel(int dancerId) async {
    // Check if dancer is regular (3+ events in last 2 months)
    if (await _isDancerRegular(dancerId)) {
      return ActivityLevel.regular;
    }

    // Check if dancer is occasional (1+ event in last 3 months)
    if (await _isDancerOccasional(dancerId)) {
      return ActivityLevel.occasional;
    }

    // Default to all if no recent activity
    return ActivityLevel.all;
  }
}
