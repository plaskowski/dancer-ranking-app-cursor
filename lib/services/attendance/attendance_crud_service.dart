import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';

class AttendanceCrudService {
  final AppDatabase _database;

  AttendanceCrudService(this._database);

  // Mark a dancer as present at an event
  Future<int> markPresent(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceCrudService', 'markPresent', {
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
            'AttendanceCrudService.markPresent', 'already_present', {
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
      ActionLogger.logError('AttendanceCrudService.markPresent', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Remove a dancer from the present list
  Future<int> removeFromPresent(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceCrudService', 'removeFromPresent', {
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
          'AttendanceCrudService.removeFromPresent', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Mark a dancer as left (they left before dancing)
  Future<bool> markAsLeft(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceCrudService', 'markAsLeft', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      final attendance = await getAttendance(eventId, dancerId);
      if (attendance == null) {
        ActionLogger.logAction(
            'AttendanceCrudService.markAsLeft', 'no_attendance_record', {
          'eventId': eventId,
          'dancerId': dancerId,
        });
        return false;
      }

      // Only allow marking as left if they haven't danced yet
      if (attendance.status == 'served') {
        ActionLogger.logAction(
            'AttendanceCrudService.markAsLeft', 'already_danced', {
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
      ActionLogger.logError('AttendanceCrudService.markAsLeft', e.toString(), {
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
}
