import 'package:drift/drift.dart';

import '../../database/database.dart';
import 'attendance_models.dart';

class AttendanceQueryService {
  final AppDatabase _database;

  AttendanceQueryService(this._database);

  // Helper method to create attendance-dancer join query
  JoinedSelectStatement<HasResultSet, dynamic>
      _createAttendanceDancerJoinQuery() {
    return _database.select(_database.attendances).join([
      innerJoin(_database.dancers,
          _database.dancers.id.equalsExp(_database.attendances.dancerId)),
    ]);
  }

  // Helper method to map join results to AttendanceWithDancerInfo
  List<AttendanceWithDancerInfo> _mapJoinResultsToAttendanceWithDancerInfo(
      List<TypedResult> results) {
    return results.map((row) {
      final attendance = row.readTable(_database.attendances);
      final dancer = row.readTable(_database.dancers);

      return AttendanceWithDancerInfo(
        id: attendance.id,
        eventId: attendance.eventId,
        dancerId: attendance.dancerId,
        markedAt: attendance.markedAt,
        status: attendance.status,
        dancedAt: attendance.dancedAt,
        impression: attendance.impression,
        scoreId: attendance.scoreId,
        dancerName: dancer.name,
        dancerNotes: dancer.notes,
      );
    }).toList();
  }

  // Get present dancers with their info
  Future<List<AttendanceWithDancerInfo>> getPresentDancersWithInfo(
      int eventId) async {
    final query = _createAttendanceDancerJoinQuery()
      ..where(_database.attendances.eventId.equals(eventId))
      ..orderBy([OrderingTerm.desc(_database.attendances.markedAt)]);

    final results = await query.get();
    return _mapJoinResultsToAttendanceWithDancerInfo(results);
  }

  // Get danced dancers for an event
  Future<List<AttendanceWithDancerInfo>> getDancedDancers(int eventId) async {
    final query = _createAttendanceDancerJoinQuery()
      ..where(_database.attendances.eventId.equals(eventId) &
          _database.attendances.status.equals('served'))
      ..orderBy([OrderingTerm.desc(_database.attendances.dancedAt)]);

    final results = await query.get();
    return _mapJoinResultsToAttendanceWithDancerInfo(results);
  }
}
