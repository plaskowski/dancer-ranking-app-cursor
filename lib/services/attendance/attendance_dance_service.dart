import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'attendance_crud_service.dart';

class AttendanceDanceService {
  final AppDatabase _database;
  final AttendanceCrudService _crudService;

  AttendanceDanceService(this._database, this._crudService);

  // Record a dance with impression
  Future<bool> recordDance({
    required int eventId,
    required int dancerId,
    String? impression,
  }) async {
    ActionLogger.logServiceCall('AttendanceDanceService', 'recordDance', {
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
            'AttendanceDanceService.recordDance', 'creating_attendance_first', {
          'eventId': eventId,
          'dancerId': dancerId,
        });

        // Dancer not marked as present, mark them first
        await _crudService.markPresent(eventId, dancerId);

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
            'AttendanceDanceService.recordDance', 'updating_existing', {
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
      ActionLogger.logError(
          'AttendanceDanceService.recordDance', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
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
    final attendance = await _crudService.getAttendance(eventId, dancerId);
    if (attendance == null) return false;

    return _database.update(_database.attendances).replace(
          attendance.copyWith(
            impression: Value(impression),
          ),
        );
  }
}
