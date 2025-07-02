import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'dancer_models.dart';

class DancerEventService {
  final AppDatabase _database;

  DancerEventService(this._database);

  // Watch all dancers for a specific event (for event screen tabs)
  Stream<List<DancerWithEventInfo>> watchDancersForEvent(int eventId) {
    ActionLogger.logServiceCall('DancerEventService', 'watchDancersForEvent', {
      'eventId': eventId,
    });

    final query = _database.select(_database.dancers).join([
      // LEFT JOIN rankings ON dancers.id = rankings.dancer_id AND rankings.event_id = eventId
      leftOuterJoin(
        _database.rankings,
        _database.dancers.id.equalsExp(_database.rankings.dancerId) &
            _database.rankings.eventId.equals(eventId),
      ),
      // LEFT JOIN ranks ON rankings.rank_id = ranks.id
      leftOuterJoin(
        _database.ranks,
        _database.rankings.rankId.equalsExp(_database.ranks.id),
      ),
      // LEFT JOIN attendances ON dancers.id = attendances.dancer_id AND attendances.event_id = eventId
      leftOuterJoin(
        _database.attendances,
        _database.dancers.id.equalsExp(_database.attendances.dancerId) &
            _database.attendances.eventId.equals(eventId),
      ),
      // LEFT JOIN scores ON attendances.score_id = scores.id
      leftOuterJoin(
        _database.scores,
        _database.attendances.scoreId.equalsExp(_database.scores.id),
      ),
    ])
      ..orderBy([OrderingTerm.asc(_database.dancers.name)]);

    return query.watch().asyncMap((result) async {
      // For each dancer, compute if this event is their first served attendance
      final dancersWithFirstMet = <DancerWithEventInfo>[];

      for (final row in result) {
        final dancer = row.readTable(_database.dancers);
        final ranking = row.readTableOrNull(_database.rankings);
        final rank = row.readTableOrNull(_database.ranks);
        final attendance = row.readTableOrNull(_database.attendances);
        final score = row.readTableOrNull(_database.scores);

        // Compute if this is the first attendance for this dancer (regardless of status)
        bool isFirstMetHere = false;
        if (attendance != null) {
          // Get current event date for comparison
          final currentEvent = await (_database.select(_database.events)
                ..where((e) => e.id.equals(eventId)))
              .getSingleOrNull();

          if (currentEvent != null) {
            // Check if firstMetDate is before current event date
            final bool hasEarlierFirstMet = dancer.firstMetDate != null &&
                dancer.firstMetDate!.isBefore(currentEvent.date);

            if (hasEarlierFirstMet) {
              // If firstMetDate is before this event, not first met here
              isFirstMetHere = false;
            } else {
              // Get earliest attendance for this dancer across all events (exclude 'absent' status)
              final earliestAttendance =
                  await (_database.select(_database.attendances).join([
                innerJoin(
                    _database.events,
                    _database.attendances.eventId
                        .equalsExp(_database.events.id)),
              ])
                        ..where(_database.attendances.dancerId
                                .equals(dancer.id) &
                            _database.attendances.status.isNotValue('absent'))
                        ..orderBy([OrderingTerm.asc(_database.events.date)])
                        ..limit(1))
                      .getSingleOrNull();

              final earliestAttendanceRecord =
                  earliestAttendance?.readTable(_database.attendances);

              // This is first met if this attendance is the earliest attendance
              isFirstMetHere = earliestAttendanceRecord?.eventId == eventId;
            }
          }
        }

        dancersWithFirstMet.add(DancerWithEventInfo(
          id: dancer.id,
          name: dancer.name,
          notes: dancer.notes,
          createdAt: dancer.createdAt,
          firstMetDate: dancer.firstMetDate,
          rankName: rank?.name,
          rankOrdinal: rank?.ordinal,
          rankingReason: ranking?.reason,
          rankingUpdated: ranking?.lastUpdated,
          attendanceMarkedAt: attendance?.markedAt,
          status: attendance?.status ?? 'absent',
          dancedAt: attendance?.dancedAt,
          impression: attendance?.impression,
          scoreName: score?.name,
          scoreOrdinal: score?.ordinal,
          scoreId: score?.id,
          isFirstMetHere: isFirstMetHere,
        ));
      }

      return dancersWithFirstMet;
    });
  }

  // Get only dancers that don't have rankings for a specific event AND are not present (for selection dialog)
  Future<List<DancerWithEventInfo>> getUnrankedDancersForEvent(
      int eventId) async {
    ActionLogger.logServiceCall(
        'DancerEventService', 'getUnrankedDancersForEvent', {
      'eventId': eventId,
    });

    try {
      // Get all ranked dancer IDs for this event
      final rankedDancerIdsDebug = await (_database.select(_database.rankings)
            ..where((r) => r.eventId.equals(eventId)))
          .get();

      // Get all present dancer IDs for this event
      final presentDancerIds = await (_database.select(_database.attendances)
            ..where((a) => a.eventId.equals(eventId)))
          .get();

      print(
          'DEBUG: Ranked dancer IDs for event $eventId: ${rankedDancerIdsDebug.map((r) => r.dancerId).toList()}');
      print(
          'DEBUG: Present dancer IDs for event $eventId: ${presentDancerIds.map((a) => a.dancerId).toList()}');

      // Get all dancers
      final allDancers = await (_database.select(_database.dancers)
            ..orderBy([(d) => OrderingTerm.asc(d.name)]))
          .get();

      // Filter out dancers that have rankings OR are present for this event
      final rankedDancerIds =
          rankedDancerIdsDebug.map((r) => r.dancerId).toSet();
      final presentDancerIdSet =
          presentDancerIds.map((a) => a.dancerId).toSet();
      final availableDancers = allDancers
          .where((dancer) =>
              !rankedDancerIds.contains(dancer.id) &&
              !presentDancerIdSet.contains(dancer.id))
          .toList();

      print('DEBUG: All dancers count: ${allDancers.length}');
      print('DEBUG: Ranked dancers count: ${rankedDancerIds.length}');
      print('DEBUG: Present dancers count: ${presentDancerIdSet.length}');
      print(
          'DEBUG: Available (unranked + absent) dancers count: ${availableDancers.length}');
      print(
          'DEBUG: Available dancer names: ${availableDancers.map((d) => d.name).toList()}');

      ActionLogger.logAction('DancerEventService.getUnrankedDancersForEvent',
          'filtering_complete', {
        'eventId': eventId,
        'totalDancers': allDancers.length,
        'rankedDancers': rankedDancerIds.length,
        'presentDancers': presentDancerIdSet.length,
        'availableDancers': availableDancers.length,
      });

      return availableDancers.map((dancer) {
        return DancerWithEventInfo(
          id: dancer.id,
          name: dancer.name,
          notes: dancer.notes,
          createdAt: dancer.createdAt,
          status: 'absent',
          isFirstMetHere: false, // Absent dancers are not first met here
        );
      }).toList();
    } catch (e) {
      ActionLogger.logError(
          'DancerEventService.getUnrankedDancersForEvent', e.toString(), {
        'eventId': eventId,
      });
      rethrow;
    }
  }
}
