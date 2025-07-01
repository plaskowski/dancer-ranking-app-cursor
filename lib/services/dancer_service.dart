import 'package:drift/drift.dart';

import '../database/database.dart';
import '../models/dancer_with_tags.dart';
import '../utils/action_logger.dart';

class DancerService {
  final AppDatabase _database;

  DancerService(this._database);

  // Get all dancers ordered by name
  Stream<List<Dancer>> watchAllDancers() {
    ActionLogger.logServiceCall('DancerService', 'watchAllDancers');

    return (_database.select(_database.dancers)
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Get a specific dancer by ID
  Future<Dancer?> getDancer(int id) {
    ActionLogger.logServiceCall('DancerService', 'getDancer', {'dancerId': id});

    return (_database.select(_database.dancers)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
  }

  // Search dancers by name
  Stream<List<Dancer>> searchDancers(String query) {
    ActionLogger.logServiceCall('DancerService', 'searchDancers', {
      'query': query,
      'queryLength': query.length,
    });

    if (query.isEmpty) {
      return watchAllDancers();
    }

    return (_database.select(_database.dancers)
          ..where((d) => d.name.contains(query))
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Create a new dancer
  Future<int> createDancer({required String name, String? notes}) async {
    ActionLogger.logServiceCall('DancerService', 'createDancer', {
      'name': name,
      'hasNotes': notes != null,
    });

    try {
      final id = await _database.into(_database.dancers).insert(
            DancersCompanion.insert(
              name: name,
              notes: Value(notes),
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'dancers', {
        'id': id,
        'name': name,
        'notes': notes,
      });

      return id;
    } catch (e) {
      ActionLogger.logError('DancerService.createDancer', e.toString(), {
        'name': name,
        'hasNotes': notes != null,
      });
      rethrow;
    }
  }

  // Update an existing dancer
  Future<bool> updateDancer(int id, {String? name, String? notes}) async {
    ActionLogger.logServiceCall('DancerService', 'updateDancer', {
      'dancerId': id,
      'hasName': name != null,
      'hasNotes': notes != null,
    });

    try {
      final dancer = await getDancer(id);
      if (dancer == null) {
        ActionLogger.logAction(
            'DancerService.updateDancer', 'dancer_not_found', {
          'dancerId': id,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              name: name ?? dancer.name,
              notes: Value(notes ?? dancer.notes),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers', {
        'id': id,
        'oldName': dancer.name,
        'newName': name ?? dancer.name,
        'oldNotes': dancer.notes,
        'newNotes': notes ?? dancer.notes,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerService.updateDancer', e.toString(), {
        'dancerId': id,
        'name': name,
        'notes': notes,
      });
      rethrow;
    }
  }

  // Update first met date for a dancer (for dancers met before event tracking)
  Future<bool> updateFirstMetDate(int id, DateTime? firstMetDate) async {
    ActionLogger.logServiceCall('DancerService', 'updateFirstMetDate', {
      'dancerId': id,
      'firstMetDate': firstMetDate?.toIso8601String(),
    });

    try {
      final dancer = await getDancer(id);
      if (dancer == null) {
        ActionLogger.logError(
            'DancerService.updateFirstMetDate', 'dancer_not_found', {
          'dancerId': id,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              firstMetDate: Value(firstMetDate),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers', {
        'id': id,
        'oldFirstMetDate': dancer.firstMetDate?.toIso8601String(),
        'newFirstMetDate': firstMetDate?.toIso8601String(),
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerService.updateFirstMetDate', e.toString(), {
        'dancerId': id,
        'firstMetDate': firstMetDate?.toIso8601String(),
      });
      return false;
    }
  }

  // Delete a dancer (this will cascade delete rankings and attendances)
  Future<int> deleteDancer(int id) async {
    ActionLogger.logServiceCall('DancerService', 'deleteDancer', {
      'dancerId': id,
    });

    try {
      final result = await (_database.delete(_database.dancers)
            ..where((d) => d.id.equals(id)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'dancers', {
        'id': id,
        'affected_rows': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerService.deleteDancer', e.toString(), {
        'dancerId': id,
      });
      rethrow;
    }
  }

  // Get dancers count
  Future<int> getDancersCount() async {
    ActionLogger.logServiceCall('DancerService', 'getDancersCount');

    try {
      final countExp = countAll();
      final query = _database.selectOnly(_database.dancers)
        ..addColumns([countExp]);

      final result = await query.getSingle();
      final count = result.read(countExp)!;

      ActionLogger.logAction(
          'DancerService.getDancersCount', 'count_retrieved', {
        'count': count,
      });

      return count;
    } catch (e) {
      ActionLogger.logError('DancerService.getDancersCount', e.toString());
      rethrow;
    }
  }

  // Watch all dancers for a specific event (for event screen tabs)
  Stream<List<DancerWithEventInfo>> watchDancersForEvent(int eventId) {
    ActionLogger.logServiceCall('DancerService', 'watchDancersForEvent', {
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

        // Compute if this is the first served attendance for this dancer
        bool isFirstMetHere = false;
        if (attendance?.status == 'served') {
          // Get earliest served attendance for this dancer across all events
          final earliestServed = await (_database.select(_database.attendances)
                ..where((a) =>
                    a.dancerId.equals(dancer.id) & a.status.equals('served'))
                ..orderBy([(a) => OrderingTerm.asc(a.markedAt)])
                ..limit(1))
              .getSingleOrNull();

          // This is first met if this attendance is the earliest served attendance
          isFirstMetHere = earliestServed?.eventId == eventId;
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
    ActionLogger.logServiceCall('DancerService', 'getUnrankedDancersForEvent', {
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

      ActionLogger.logAction(
          'DancerService.getUnrankedDancersForEvent', 'filtering_complete', {
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
          'DancerService.getUnrankedDancersForEvent', e.toString(), {
        'eventId': eventId,
      });
      rethrow;
    }
  }

  // Get dancers with their tags for display
  Future<List<DancerWithTags>> getDancersWithTags() async {
    ActionLogger.logServiceCall('DancerService', 'getDancersWithTags');

    try {
      final dancers = await (_database.select(_database.dancers)
            ..orderBy([(d) => OrderingTerm.asc(d.name)]))
          .get();

      final dancersWithTags = <DancerWithTags>[];

      for (final dancer in dancers) {
        // Get tags for this dancer
        final tagQuery = _database.select(_database.tags).join([
          innerJoin(
            _database.dancerTags,
            _database.tags.id.equalsExp(_database.dancerTags.tagId),
          ),
        ])
          ..where(_database.dancerTags.dancerId.equals(dancer.id))
          ..orderBy([OrderingTerm.asc(_database.tags.name)]);

        final tagResults = await tagQuery.get();
        final tags =
            tagResults.map((row) => row.readTable(_database.tags)).toList();

        dancersWithTags.add(DancerWithTags(
          dancer: dancer,
          tags: tags,
        ));
      }

      return dancersWithTags;
    } catch (e) {
      ActionLogger.logError('DancerService.getDancersWithTags', e.toString());
      rethrow;
    }
  }

  // Watch dancers with their tags for reactive updates
  Stream<List<DancerWithTags>> watchDancersWithTags() {
    ActionLogger.logServiceCall('DancerService', 'watchDancersWithTags');

    // Use the existing watchAllDancers stream and transform it
    return watchAllDancers().asyncMap((_) async {
      return await getDancersWithTags();
    });
  }
}

// Helper class to combine dancer info with event-specific data
class DancerWithEventInfo {
  final int id;
  final String name;
  final String? notes;
  final DateTime createdAt;
  final DateTime? firstMetDate;
  final String? rankName;
  final int? rankOrdinal;
  final String? rankingReason;
  final DateTime? rankingUpdated;
  final DateTime? attendanceMarkedAt;
  final String status; // present, served, left, absent
  final DateTime? dancedAt;
  final String? impression;
  final String? scoreName;
  final int? scoreOrdinal;
  final int? scoreId;
  final bool isFirstMetHere;

  DancerWithEventInfo({
    required this.id,
    required this.name,
    this.notes,
    required this.createdAt,
    this.firstMetDate,
    this.rankName,
    this.rankOrdinal,
    this.rankingReason,
    this.rankingUpdated,
    this.attendanceMarkedAt,
    required this.status,
    this.dancedAt,
    this.impression,
    this.scoreName,
    this.scoreOrdinal,
    this.scoreId,
    required this.isFirstMetHere,
  });

  // Helper getters
  bool get isPresent => attendanceMarkedAt != null;
  bool get hasRanking => rankName != null;
  bool get isRanked => hasRanking;
  bool get hasScore => scoreName != null;

  // Status-based convenience getters for backward compatibility
  bool get hasDanced => status == 'served';
  bool get hasLeft => status == 'left';
  bool get isAbsent => status == 'absent';
}
