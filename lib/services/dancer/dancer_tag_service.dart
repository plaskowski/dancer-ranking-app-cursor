import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../utils/action_logger.dart';
import 'dancer_crud_service.dart';
import 'dancer_models.dart';

class DancerTagService {
  final AppDatabase _database;
  final DancerCrudService _crudService;

  DancerTagService(this._database, this._crudService);

  // Get dancers with their tags for display
  Future<List<DancerWithTags>> getDancersWithTags() async {
    ActionLogger.logServiceCall('DancerTagService', 'getDancersWithTags');

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
      ActionLogger.logError(
          'DancerTagService.getDancersWithTags', e.toString());
      rethrow;
    }
  }

  // Watch dancers with their tags for reactive updates
  Stream<List<DancerWithTags>> watchDancersWithTags() {
    ActionLogger.logServiceCall('DancerTagService', 'watchDancersWithTags');

    // Use the existing watchAllDancers stream and transform it
    return _crudService.watchAllDancers().asyncMap((_) async {
      return await getDancersWithTags();
    });
  }

  // Get active dancers with their tags for display
  Future<List<DancerWithTags>> getActiveDancersWithTags() async {
    ActionLogger.logServiceCall('DancerTagService', 'getActiveDancersWithTags');

    try {
      final dancers = await (_database.select(_database.dancers)
            ..where((d) => d.isArchived.equals(false))
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
      ActionLogger.logError(
          'DancerTagService.getActiveDancersWithTags', e.toString());
      rethrow;
    }
  }

  // Watch active dancers with their tags for reactive updates
  Stream<List<DancerWithTags>> watchActiveDancersWithTags() {
    ActionLogger.logServiceCall(
        'DancerTagService', 'watchActiveDancersWithTags');

    // Use the existing watchAllDancers stream and transform it
    return _crudService.watchAllDancers().asyncMap((_) async {
      return await getActiveDancersWithTags();
    });
  }

  // Get archived dancers with their tags for display
  Future<List<DancerWithTags>> getArchivedDancersWithTags() async {
    ActionLogger.logServiceCall(
        'DancerTagService', 'getArchivedDancersWithTags');

    try {
      final dancers = await (_database.select(_database.dancers)
            ..where((d) => d.isArchived.equals(true))
            ..orderBy([
              (d) => OrderingTerm.desc(d.archivedAt),
              (d) => OrderingTerm.asc(d.name)
            ]))
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
      ActionLogger.logError(
          'DancerTagService.getArchivedDancersWithTags', e.toString());
      rethrow;
    }
  }

  // Watch archived dancers with their tags for reactive updates
  Stream<List<DancerWithTags>> watchArchivedDancersWithTags() {
    ActionLogger.logServiceCall(
        'DancerTagService', 'watchArchivedDancersWithTags');

    // Use the existing watchAllDancers stream and transform it
    return _crudService.watchAllDancers().asyncMap((_) async {
      return await getArchivedDancersWithTags();
    });
  }

  // Get unranked dancers for event filtered by single tag
  Future<List<DancerWithEventInfo>> getUnrankedDancersForEventByTag(
    int eventId,
    int tagId,
  ) async {
    ActionLogger.logServiceCall(
        'DancerTagService', 'getUnrankedDancersForEventByTag', {
      'eventId': eventId,
      'tagId': tagId,
    });

    try {
      // First get dancers with the specific tag
      final dancersWithTag = await (_database.select(_database.dancers).join([
        innerJoin(
          _database.dancerTags,
          _database.dancers.id.equalsExp(_database.dancerTags.dancerId),
        ),
      ])
            ..where(_database.dancerTags.tagId.equals(tagId))
            ..orderBy([OrderingTerm.asc(_database.dancers.name)]))
          .get();

      final dancers = dancersWithTag
          .map((row) => row.readTable(_database.dancers))
          .toList();

      // Now filter these dancers to only include unranked ones for the event
      final unrankedDancers = <DancerWithEventInfo>[];

      for (final dancer in dancers) {
        // Check if dancer is already ranked for this event
        final ranking = await (_database.select(_database.rankings)
              ..where((r) =>
                  r.eventId.equals(eventId) & r.dancerId.equals(dancer.id)))
            .getSingleOrNull();

        if (ranking == null) {
          // Get attendance info if exists
          final attendance = await (_database.select(_database.attendances)
                ..where((a) =>
                    a.eventId.equals(eventId) & a.dancerId.equals(dancer.id)))
              .getSingleOrNull();

          // Create DancerWithEventInfo
          unrankedDancers.add(DancerWithEventInfo(
            id: dancer.id,
            name: dancer.name,
            notes: dancer.notes,
            createdAt: dancer.createdAt,
            firstMetDate: dancer.firstMetDate,
            attendanceMarkedAt: attendance?.markedAt,
            status: attendance?.status ?? 'absent',
            impression: attendance?.impression,
            isFirstMetHere: false, // Will be calculated later if needed
          ));
        }
      }

      return unrankedDancers;
    } catch (e) {
      ActionLogger.logError(
          'DancerTagService.getUnrankedDancersForEventByTag', e.toString(), {
        'eventId': eventId,
        'tagId': tagId,
      });
      rethrow;
    }
  }

  // Get available dancers for add existing dialog filtered by single tag
  Stream<List<DancerWithEventInfo>> watchAvailableDancersForEventByTag(
    int eventId,
    int tagId,
  ) {
    ActionLogger.logServiceCall(
        'DancerTagService', 'watchAvailableDancersForEventByTag', {
      'eventId': eventId,
      'tagId': tagId,
    });

    // Watch for changes in rankings, attendances, and dancer_tags, then filter by tag
    return _database.select(_database.rankings).watch().asyncMap((_) async {
      return await getAvailableDancersForEventByTag(eventId, tagId);
    });
  }

  // Helper method for available dancers (unranked and absent) filtered by tag
  Future<List<DancerWithEventInfo>> getAvailableDancersForEventByTag(
    int eventId,
    int tagId,
  ) async {
    ActionLogger.logServiceCall(
        'DancerTagService', 'getAvailableDancersForEventByTag', {
      'eventId': eventId,
      'tagId': tagId,
    });

    try {
      // First get dancers with the specific tag
      final dancersWithTag = await (_database.select(_database.dancers).join([
        innerJoin(
          _database.dancerTags,
          _database.dancers.id.equalsExp(_database.dancerTags.dancerId),
        ),
      ])
            ..where(_database.dancerTags.tagId.equals(tagId))
            ..orderBy([OrderingTerm.asc(_database.dancers.name)]))
          .get();

      final dancers = dancersWithTag
          .map((row) => row.readTable(_database.dancers))
          .toList();

      // Filter to only include unranked and absent dancers
      final availableDancers = <DancerWithEventInfo>[];

      for (final dancer in dancers) {
        // Check if dancer is already ranked for this event
        final ranking = await (_database.select(_database.rankings)
              ..where((r) =>
                  r.eventId.equals(eventId) & r.dancerId.equals(dancer.id)))
            .getSingleOrNull();

        // Check attendance status
        final attendance = await (_database.select(_database.attendances)
              ..where((a) =>
                  a.eventId.equals(eventId) & a.dancerId.equals(dancer.id)))
            .getSingleOrNull();

        // Include only unranked and absent dancers
        final isUnranked = ranking == null;
        final isAbsent = attendance == null;

        if (isUnranked && isAbsent) {
          availableDancers.add(DancerWithEventInfo(
            id: dancer.id,
            name: dancer.name,
            notes: dancer.notes,
            createdAt: dancer.createdAt,
            firstMetDate: dancer.firstMetDate,
            status: 'absent',
            isFirstMetHere: false,
          ));
        }
      }

      return availableDancers;
    } catch (e) {
      ActionLogger.logError(
          'DancerTagService.getAvailableDancersForEventByTag', e.toString(), {
        'eventId': eventId,
        'tagId': tagId,
      });
      rethrow;
    }
  }

  // Get dancers with their tags and last met event info for display
  Future<List<DancerWithTags>> getDancersWithTagsAndLastMet() async {
    ActionLogger.logServiceCall(
        'DancerTagService', 'getDancersWithTagsAndLastMet');

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

        // Get last met event info (latest attendance, not absent)
        final lastAttendanceRow =
            await (_database.select(_database.attendances).join([
          innerJoin(_database.events,
              _database.attendances.eventId.equalsExp(_database.events.id)),
        ])
                  ..where(_database.attendances.dancerId.equals(dancer.id) &
                      _database.attendances.status.isNotValue('absent'))
                  ..orderBy([OrderingTerm.desc(_database.events.date)])
                  ..limit(1))
                .getSingleOrNull();

        String? lastMetEventName;
        DateTime? lastMetEventDate;
        if (lastAttendanceRow != null) {
          final event = lastAttendanceRow.readTable(_database.events);
          lastMetEventName = event.name;
          lastMetEventDate = event.date;
        }

        dancersWithTags.add(DancerWithTags(
          dancer: dancer,
          tags: tags,
          lastMetEventName: lastMetEventName,
          lastMetEventDate: lastMetEventDate,
        ));
      }

      return dancersWithTags;
    } catch (e) {
      ActionLogger.logError(
          'DancerTagService.getDancersWithTagsAndLastMet', e.toString());
      rethrow;
    }
  }

  // Watch dancers with their tags and last met event info for reactive updates
  Stream<List<DancerWithTags>> watchDancersWithTagsAndLastMet() {
    ActionLogger.logServiceCall(
        'DancerTagService', 'watchDancersWithTagsAndLastMet');

    // Watch for changes in dancers, attendances, events, and dancer_tags, then transform
    return _database.select(_database.dancers).watch().asyncMap((_) async {
      return await getDancersWithTagsAndLastMet();
    });
  }
}
