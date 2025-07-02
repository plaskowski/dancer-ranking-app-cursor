import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'attendance_crud_service.dart';

class AttendanceScoreService {
  final AppDatabase _database;
  final AttendanceCrudService _crudService;

  AttendanceScoreService(this._database, this._crudService);

  // Assign a score to an attendance record
  Future<bool> assignScore(int eventId, int dancerId, int scoreId) async {
    ActionLogger.logServiceCall('AttendanceScoreService', 'assignScore', {
      'eventId': eventId,
      'dancerId': dancerId,
      'scoreId': scoreId,
    });

    try {
      final attendance = await _crudService.getAttendance(eventId, dancerId);
      if (attendance == null) {
        ActionLogger.logError(
            'AttendanceScoreService.assignScore', 'attendance_not_found', {
          'eventId': eventId,
          'dancerId': dancerId,
        });
        return false;
      }

      final result = await _database.update(_database.attendances).replace(
            attendance.copyWith(
              scoreId: Value(scoreId),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'attendances', {
        'id': attendance.id,
        'eventId': eventId,
        'dancerId': dancerId,
        'scoreId': scoreId,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'AttendanceScoreService.assignScore', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
        'scoreId': scoreId,
      });
      return false;
    }
  }

  // Remove score assignment from an attendance record
  Future<bool> removeScore(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('AttendanceScoreService', 'removeScore', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      final attendance = await _crudService.getAttendance(eventId, dancerId);
      if (attendance == null) {
        ActionLogger.logError(
            'AttendanceScoreService.removeScore', 'attendance_not_found', {
          'eventId': eventId,
          'dancerId': dancerId,
        });
        return false;
      }

      final result = await _database.update(_database.attendances).replace(
            attendance.copyWith(
              scoreId: const Value(null),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'attendances', {
        'id': attendance.id,
        'eventId': eventId,
        'dancerId': dancerId,
        'action': 'remove_score',
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'AttendanceScoreService.removeScore', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      return false;
    }
  }

  // Get current score for an attendance record
  Future<int?> getAttendanceScore(int eventId, int dancerId) async {
    final attendance = await _crudService.getAttendance(eventId, dancerId);
    return attendance?.scoreId;
  }
}
