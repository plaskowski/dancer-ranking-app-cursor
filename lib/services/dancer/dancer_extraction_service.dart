import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';

class DancerExtractionService {
  final AppDatabase _database;

  DancerExtractionService(this._database);

  /// Extract a dance record as a new one-time person
  /// Returns true if successful, false otherwise
  Future<bool> extractDanceRecordAsOneTimePerson(
    int attendanceId,
    String originalDancerName,
  ) async {
    ActionLogger.logUserAction(
        'DancerExtractionService', 'extractDanceRecordAsOneTimePerson', {
      'attendanceId': attendanceId,
      'originalDancerName': originalDancerName,
    });

    return await _database.transaction(() async {
      try {
        // 1. Get the attendance record with event details
        final attendanceQuery = _database.select(_database.attendances)
          ..where((a) => a.id.equals(attendanceId));

        final attendance = await attendanceQuery.getSingleOrNull();
        if (attendance == null) {
          ActionLogger.logError(
              'DancerExtractionService', 'attendance_not_found', {
            'attendanceId': attendanceId,
          });
          return false;
        }

        // 2. Get the event details
        final eventQuery = _database.select(_database.events)
          ..where((e) => e.id.equals(attendance.eventId));

        final event = await eventQuery.getSingleOrNull();
        if (event == null) {
          ActionLogger.logError('DancerExtractionService', 'event_not_found', {
            'eventId': attendance.eventId,
          });
          return false;
        }

        // 3. Create new dancer with name "[OriginalDancerName] - [EventName]"
        final newDancerName = '$originalDancerName - ${event.name}';
        final newDancerId = await _database.into(_database.dancers).insert(
              DancersCompanion.insert(
                name: newDancerName,
                notes: Value('Extracted from $originalDancerName'),
                firstMetDate: Value(event.date),
              ),
            );

        // 4. Copy the attendance record to the new dancer
        await _database.into(_database.attendances).insert(
              AttendancesCompanion.insert(
                eventId: attendance.eventId,
                dancerId: newDancerId,
                markedAt: Value(attendance.markedAt),
                status: Value(attendance.status),
                dancedAt: Value(attendance.dancedAt),
                impression: Value(attendance.impression),
                scoreId: Value(attendance.scoreId),
              ),
            );

        // 5. Delete the original attendance record
        await (_database.delete(_database.attendances)
              ..where((a) => a.id.equals(attendanceId)))
            .go();

        ActionLogger.logUserAction('DancerExtractionService',
            'extractDanceRecordAsOneTimePerson_success', {
          'attendanceId': attendanceId,
          'originalDancerName': originalDancerName,
          'newDancerId': newDancerId,
          'newDancerName': newDancerName,
          'eventName': event.name,
        });

        return true;
      } catch (e) {
        ActionLogger.logError('DancerExtractionService',
            'extractDanceRecordAsOneTimePerson_failed', {
          'attendanceId': attendanceId,
          'originalDancerName': originalDancerName,
          'error': e.toString(),
        });
        return false;
      }
    });
  }
}
