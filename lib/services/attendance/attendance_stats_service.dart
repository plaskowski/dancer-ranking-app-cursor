import 'package:drift/drift.dart';

import '../../database/database.dart';
import 'attendance_models.dart';

class AttendanceStatsService {
  final AppDatabase _database;

  AttendanceStatsService(this._database);

  // Get present count for an event
  Future<int> getPresentCount(int eventId) async {
    final query = _database.selectOnly(_database.attendances)
      ..addColumns([_database.attendances.id.count()])
      ..where(_database.attendances.eventId.equals(eventId));

    final result = await query.getSingle();
    return result.read(_database.attendances.id.count()) ?? 0;
  }

  // Get danced count for an event
  Future<int> getDancedCount(int eventId) async {
    final query = _database.selectOnly(_database.attendances)
      ..addColumns([_database.attendances.id.count()])
      ..where(_database.attendances.eventId.equals(eventId) &
          _database.attendances.status.equals('served'));

    final result = await query.getSingle();
    return result.read(_database.attendances.id.count()) ?? 0;
  }

  // Get attendance statistics for an event
  Future<AttendanceStats> getAttendanceStats(int eventId) async {
    final presentCount = await getPresentCount(eventId);
    final dancedCount = await getDancedCount(eventId);

    return AttendanceStats(
      presentCount: presentCount,
      dancedCount: dancedCount,
      notDancedCount: presentCount - dancedCount,
    );
  }
}
