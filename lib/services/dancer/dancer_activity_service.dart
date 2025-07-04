import '../../database/database.dart';
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
    // For now, use the existing dancer event service
    // This will be enhanced with proper activity filtering
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

  Stream<List<DancerWithEventInfo>> _getActiveDancers(
    int eventId, {
    required int months,
    required int minEvents,
  }) {
    final dancerEventService = DancerEventService(_database);

    return dancerEventService.watchDancersForEvent(eventId).map((dancers) {
      return dancers.where((dancer) {
        // For now, we'll use a simple approach - count recent attendances
        // This will be enhanced when we have better attendance history
        return true; // Placeholder - will implement proper filtering
      }).toList();
    });
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
    // For now, return all as default
    // This will be enhanced when we have better attendance history tracking
    return ActivityLevel.all;
  }
}
