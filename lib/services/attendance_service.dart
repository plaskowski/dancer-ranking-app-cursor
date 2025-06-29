import 'package:drift/drift.dart';

import '../database/database.dart';
import '../utils/action_logger.dart';

class AttendanceService {
  final AppDatabase _database;

  AttendanceService(this._database);

  // Mark a dancer as present at an event
  Future<int> markPresent(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceService', 'markPresent', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      // Check if attendance already exists
      final existingAttendance = await (_database.select(_database.attendances)
            ..where(
                (a) => a.eventId.equals(eventId) & a.dancerId.equals(dancerId)))
          .getSingleOrNull();

      if (existingAttendance != null) {
        ActionLogger.logAction(
            'AttendanceService.markPresent', 'already_present', {
          'eventId': eventId,
          'dancerId': dancerId,
          'attendanceId': existingAttendance.id,
        });
        return existingAttendance.id;
      }

      // Create new attendance record
      final id = await _database.into(_database.attendances).insert(
            AttendancesCompanion.insert(
              eventId: eventId,
              dancerId: dancerId,
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'attendances', {
        'id': id,
        'eventId': eventId,
        'dancerId': dancerId,
        'status': 'present',
      });

      return id;
    } catch (e) {
      ActionLogger.logError('AttendanceService.markPresent', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Remove a dancer from the present list
  Future<int> removeFromPresent(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceService', 'removeFromPresent', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      final result = await (_database.delete(_database.attendances)
            ..where(
                (a) => a.eventId.equals(eventId) & a.dancerId.equals(dancerId)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'attendances', {
        'eventId': eventId,
        'dancerId': dancerId,
        'affected_rows': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'AttendanceService.removeFromPresent', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Mark a dancer as left (they left before dancing)
  Future<bool> markAsLeft(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceService', 'markAsLeft', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      final attendance = await getAttendance(eventId, dancerId);
      if (attendance == null) {
        ActionLogger.logAction(
            'AttendanceService.markAsLeft', 'no_attendance_record', {
          'eventId': eventId,
          'dancerId': dancerId,
        });
        return false;
      }

      // Only allow marking as left if they haven't danced yet
      if (attendance.status == 'served') {
        ActionLogger.logAction(
            'AttendanceService.markAsLeft', 'already_danced', {
          'eventId': eventId,
          'dancerId': dancerId,
          'currentStatus': attendance.status,
        });
        return false;
      }

      final result = await _database.update(_database.attendances).replace(
            attendance.copyWith(
              status: 'left',
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'attendances', {
        'id': attendance.id,
        'eventId': eventId,
        'dancerId': dancerId,
        'oldStatus': attendance.status,
        'newStatus': 'left',
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('AttendanceService.markAsLeft', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Record a dance with impression
  Future<bool> recordDance({
    required int eventId,
    required int dancerId,
    String? impression,
  }) async {
    ActionLogger.logServiceCall('AttendanceService', 'recordDance', {
      'eventId': eventId,
      'dancerId': dancerId,
      'hasImpression': impression != null,
    });

    try {
      final attendance = await (_database.select(_database.attendances)
            ..where(
                (a) => a.eventId.equals(eventId) & a.dancerId.equals(dancerId)))
          .getSingleOrNull();

      if (attendance == null) {
        ActionLogger.logAction(
            'AttendanceService.recordDance', 'creating_attendance_first', {
          'eventId': eventId,
          'dancerId': dancerId,
        });

        // Dancer not marked as present, mark them first
        await markPresent(eventId, dancerId);

        // Get the newly created attendance record
        final newAttendance = await (_database.select(_database.attendances)
              ..where((a) =>
                  a.eventId.equals(eventId) & a.dancerId.equals(dancerId)))
            .getSingle();

        // Update with dance info
        final result = await _database.update(_database.attendances).replace(
              newAttendance.copyWith(
                status: 'served',
                dancedAt: Value(DateTime.now()),
                impression: Value(impression),
              ),
            );

        ActionLogger.logDbOperation('UPDATE', 'attendances', {
          'id': newAttendance.id,
          'eventId': eventId,
          'dancerId': dancerId,
          'action': 'record_dance_new',
          'status': 'served',
          'success': result,
        });

        return result;
      } else {
        ActionLogger.logAction(
            'AttendanceService.recordDance', 'updating_existing', {
          'eventId': eventId,
          'dancerId': dancerId,
          'currentStatus': attendance.status,
        });

        // Update existing attendance record
        final result = await _database.update(_database.attendances).replace(
              attendance.copyWith(
                status: 'served',
                dancedAt: Value(DateTime.now()),
                impression: Value(impression),
              ),
            );

        ActionLogger.logDbOperation('UPDATE', 'attendances', {
          'id': attendance.id,
          'eventId': eventId,
          'dancerId': dancerId,
          'action': 'record_dance_existing',
          'oldStatus': attendance.status,
          'newStatus': 'served',
          'success': result,
        });

        return result;
      }
    } catch (e) {
      ActionLogger.logError('AttendanceService.recordDance', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Get attendance record for a dancer at an event
  Future<Attendance?> getAttendance(int eventId, int dancerId) {
    return (_database.select(_database.attendances)
          ..where(
              (a) => a.eventId.equals(eventId) & a.dancerId.equals(dancerId)))
        .getSingleOrNull();
  }

  // Check if dancer is present at event
  Future<bool> isPresent(int eventId, int dancerId) async {
    final attendance = await getAttendance(eventId, dancerId);
    return attendance != null;
  }

  // Check if danced with dancer at event
  Future<bool> hasDanced(int eventId, int dancerId) async {
    final attendance = await getAttendance(eventId, dancerId);
    return attendance?.status == 'served';
  }

  // Get all present dancers for an event
  Stream<List<Attendance>> watchPresentDancers(int eventId) {
    return (_database.select(_database.attendances)
          ..where((a) => a.eventId.equals(eventId))
          ..orderBy([(a) => OrderingTerm.desc(a.markedAt)]))
        .watch();
  }

  // Get present dancers with their info
  Future<List<AttendanceWithDancerInfo>> getPresentDancersWithInfo(
      int eventId) async {
    const query = '''
      SELECT 
        a.*,
        d.name as dancer_name,
        d.notes as dancer_notes
      FROM attendances a
      JOIN dancers d ON a.dancer_id = d.id
      WHERE a.event_id = ?
      ORDER BY a.marked_at DESC
    ''';

    final result = await _database.customSelect(
      query,
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.attendances, _database.dancers},
    ).get();

    return result
        .map((row) => AttendanceWithDancerInfo.fromRow(row.data))
        .toList();
  }

  // Get danced dancers for an event
  Future<List<AttendanceWithDancerInfo>> getDancedDancers(int eventId) async {
    const query = '''
      SELECT 
        a.*,
        d.name as dancer_name,
        d.notes as dancer_notes
      FROM attendances a
      JOIN dancers d ON a.dancer_id = d.id
      WHERE a.event_id = ? AND a.status = 'served'
      ORDER BY a.danced_at DESC
    ''';

    final result = await _database.customSelect(
      query,
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.attendances, _database.dancers},
    ).get();

    return result
        .map((row) => AttendanceWithDancerInfo.fromRow(row.data))
        .toList();
  }

  // Get present count for an event
  Future<int> getPresentCount(int eventId) async {
    final result = await _database.customSelect(
      'SELECT COUNT(*) as count FROM attendances WHERE event_id = ?',
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.attendances},
    ).getSingle();
    return result.data['count'] as int;
  }

  // Get danced count for an event
  Future<int> getDancedCount(int eventId) async {
    final result = await _database.customSelect(
      'SELECT COUNT(*) as count FROM attendances WHERE event_id = ? AND status = \'served\'',
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.attendances},
    ).getSingle();
    return result.data['count'] as int;
  }

  // Create attendance with dance completion (for "already danced" option)
  Future<int> createAttendanceWithDance({
    required int eventId,
    required int dancerId,
    String? impression,
  }) {
    return _database.into(_database.attendances).insert(
          AttendancesCompanion.insert(
            eventId: eventId,
            dancerId: dancerId,
            status: const Value('served'),
            dancedAt: Value(DateTime.now()),
            impression: Value(impression),
          ),
        );
  }

  // Update dance impression
  Future<bool> updateDanceImpression({
    required int eventId,
    required int dancerId,
    String? impression,
  }) async {
    final attendance = await getAttendance(eventId, dancerId);
    if (attendance == null) return false;

    return _database.update(_database.attendances).replace(
          attendance.copyWith(
            impression: Value(impression),
          ),
        );
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

// Helper class for attendance with dancer info
class AttendanceWithDancerInfo {
  final int id;
  final int eventId;
  final int dancerId;
  final DateTime markedAt;
  final String status;
  final DateTime? dancedAt;
  final String? impression;
  final String dancerName;
  final String? dancerNotes;

  AttendanceWithDancerInfo({
    required this.id,
    required this.eventId,
    required this.dancerId,
    required this.markedAt,
    required this.status,
    this.dancedAt,
    this.impression,
    required this.dancerName,
    this.dancerNotes,
  });

  // Backward compatibility getter
  bool get hasDanced => status == 'served';

  factory AttendanceWithDancerInfo.fromRow(Map<String, dynamic> row) {
    return AttendanceWithDancerInfo(
      id: row['id'] as int,
      eventId: row['event_id'] as int,
      dancerId: row['dancer_id'] as int,
      markedAt: DateTime.parse(row['marked_at'] as String),
      status: row['status'] as String,
      dancedAt: row['danced_at'] != null
          ? DateTime.parse(row['danced_at'] as String)
          : null,
      impression: row['impression'] as String?,
      dancerName: row['dancer_name'] as String,
      dancerNotes: row['dancer_notes'] as String?,
    );
  }
}

// Attendance statistics
class AttendanceStats {
  final int presentCount;
  final int dancedCount;
  final int notDancedCount;

  AttendanceStats({
    required this.presentCount,
    required this.dancedCount,
    required this.notDancedCount,
  });

  double get dancedPercentage =>
      presentCount > 0 ? (dancedCount / presentCount) * 100 : 0;
}
