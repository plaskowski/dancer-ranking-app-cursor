import 'package:drift/drift.dart';
import '../database/database.dart';

class DancerService {
  final AppDatabase _database;

  DancerService(this._database);

  // Get all dancers ordered by name
  Stream<List<Dancer>> watchAllDancers() {
    return (_database.select(_database.dancers)
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Get a specific dancer by ID
  Future<Dancer?> getDancer(int id) {
    return (_database.select(_database.dancers)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
  }

  // Search dancers by name
  Stream<List<Dancer>> searchDancers(String query) {
    if (query.isEmpty) {
      return watchAllDancers();
    }

    return (_database.select(_database.dancers)
          ..where((d) => d.name.contains(query))
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Create a new dancer
  Future<int> createDancer({required String name, String? notes}) {
    return _database.into(_database.dancers).insert(
          DancersCompanion.insert(
            name: name,
            notes: Value(notes),
          ),
        );
  }

  // Update an existing dancer
  Future<bool> updateDancer(int id, {String? name, String? notes}) async {
    final dancer = await getDancer(id);
    if (dancer == null) return false;

    return _database.update(_database.dancers).replace(
          dancer.copyWith(
            name: name ?? dancer.name,
            notes: Value(notes ?? dancer.notes),
          ),
        );
  }

  // Delete a dancer (this will cascade delete rankings and attendances)
  Future<int> deleteDancer(int id) {
    return (_database.delete(_database.dancers)..where((d) => d.id.equals(id)))
        .go();
  }

  // Get dancers count
  Future<int> getDancersCount() async {
    final countExp = countAll();
    final query = _database.selectOnly(_database.dancers)
      ..addColumns([countExp]);

    final result = await query.getSingle();
    return result.read(countExp)!;
  }

  // Get dancers for a specific event (with rankings and attendance)
  Future<List<DancerWithEventInfo>> getDancersForEvent(int eventId) async {
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
    ])
      ..orderBy([OrderingTerm.asc(_database.dancers.name)]);

    final result = await query.get();

    return result.map((row) {
      final dancer = row.readTable(_database.dancers);
      final ranking = row.readTableOrNull(_database.rankings);
      final rank = row.readTableOrNull(_database.ranks);
      final attendance = row.readTableOrNull(_database.attendances);

      return DancerWithEventInfo(
        id: dancer.id,
        name: dancer.name,
        notes: dancer.notes,
        createdAt: dancer.createdAt,
        rankName: rank?.name,
        rankOrdinal: rank?.ordinal,
        rankingReason: ranking?.reason,
        rankingUpdated: ranking?.lastUpdated,
        attendanceMarkedAt: attendance?.markedAt,
        hasDanced: attendance?.hasDanced ?? false,
        dancedAt: attendance?.dancedAt,
        impression: attendance?.impression,
      );
    }).toList();
  }

  // Get only dancers that don't have rankings for a specific event (for selection dialog)
  Future<List<DancerWithEventInfo>> getUnrankedDancersForEvent(
      int eventId) async {
    // Subquery to get dancer IDs that already have rankings for this event
    final rankedDancerIds = _database.selectOnly(_database.rankings)
      ..where(_database.rankings.eventId.equals(eventId))
      ..addColumns([_database.rankings.dancerId]);

    // Main query: get dancers that are NOT in the ranked dancers subquery
    final query = _database.select(_database.dancers)
      ..where((d) => d.id.isNotInQuery(rankedDancerIds))
      ..orderBy([(d) => OrderingTerm.asc(d.name)]);

    final result = await query.get();

    return result.map((dancer) {
      return DancerWithEventInfo(
        id: dancer.id,
        name: dancer.name,
        notes: dancer.notes,
        createdAt: dancer.createdAt,
        rankName: null, // No ranking for this event
        rankOrdinal: null,
        rankingReason: null,
        rankingUpdated: null,
        attendanceMarkedAt: null, // Not present yet
        hasDanced: false,
        dancedAt: null,
        impression: null,
      );
    }).toList();
  }
}

// Helper class to combine dancer info with event-specific data
class DancerWithEventInfo {
  final int id;
  final String name;
  final String? notes;
  final DateTime createdAt;
  final String? rankName;
  final int? rankOrdinal;
  final String? rankingReason;
  final DateTime? rankingUpdated;
  final DateTime? attendanceMarkedAt;
  final bool hasDanced;
  final DateTime? dancedAt;
  final String? impression;

  DancerWithEventInfo({
    required this.id,
    required this.name,
    this.notes,
    required this.createdAt,
    this.rankName,
    this.rankOrdinal,
    this.rankingReason,
    this.rankingUpdated,
    this.attendanceMarkedAt,
    required this.hasDanced,
    this.dancedAt,
    this.impression,
  });

  // Helper getters
  bool get isPresent => attendanceMarkedAt != null;
  bool get hasRanking => rankName != null;
  bool get isRanked => hasRanking;
}
