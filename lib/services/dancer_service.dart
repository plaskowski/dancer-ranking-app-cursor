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
    return (_database.select(_database.dancers)
          ..where((d) => d.id.equals(id)))
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
    return (_database.delete(_database.dancers)
          ..where((d) => d.id.equals(id)))
        .go();
  }

  // Get dancers count
  Future<int> getDancersCount() async {
    final result = await _database.customSelect(
      'SELECT COUNT(*) as count FROM dancers',
      readsFrom: {_database.dancers},
    ).getSingle();
    return result.data['count'] as int;
  }

  // Get dancers for a specific event (with rankings and attendance)
  Future<List<DancerWithEventInfo>> getDancersForEvent(int eventId) async {
    const query = '''
      SELECT 
        d.id,
        d.name,
        d.notes,
        d.created_at,
        r.name as rank_name,
        r.ordinal as rank_ordinal,
        rk.reason as ranking_reason,
        rk.last_updated as ranking_updated,
        a.marked_at as attendance_marked_at,
        a.has_danced,
        a.danced_at,
        a.impression
      FROM dancers d
      LEFT JOIN rankings rk ON d.id = rk.dancer_id AND rk.event_id = ?
      LEFT JOIN ranks r ON rk.rank_id = r.id
      LEFT JOIN attendances a ON d.id = a.dancer_id AND a.event_id = ?
      ORDER BY d.name
    ''';

    final result = await _database.customSelect(
      query,
      variables: [Variable<int>(eventId), Variable<int>(eventId)],
      readsFrom: {_database.dancers, _database.rankings, _database.ranks, _database.attendances},
    ).get();

    return result.map((row) => DancerWithEventInfo.fromRow(row.data)).toList();
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

  factory DancerWithEventInfo.fromRow(Map<String, dynamic> row) {
    return DancerWithEventInfo(
      id: row['id'] as int,
      name: row['name'] as String,
      notes: row['notes'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      rankName: row['rank_name'] != null ? row['rank_name'] as String : null,
      rankOrdinal: row['rank_ordinal'] != null ? row['rank_ordinal'] as int : null,
      rankingReason: row['ranking_reason'] != null ? row['ranking_reason'] as String : null,
      rankingUpdated: row['ranking_updated'] != null 
        ? DateTime.parse(row['ranking_updated'] as String) 
        : null,
      attendanceMarkedAt: row['attendance_marked_at'] != null 
        ? DateTime.parse(row['attendance_marked_at'] as String) 
        : null,
      hasDanced: row['has_danced'] != null ? (row['has_danced'] as int) == 1 : false,
      dancedAt: row['danced_at'] != null 
        ? DateTime.parse(row['danced_at'] as String) 
        : null,
      impression: row['impression'] != null ? row['impression'] as String : null,
    );
  }

  // Helper getters
  bool get isPresent => attendanceMarkedAt != null;
  bool get hasRanking => rankName != null;
  bool get isRanked => hasRanking;
} 