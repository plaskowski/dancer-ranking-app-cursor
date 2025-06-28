import 'package:drift/drift.dart';
import '../database/database.dart';

class RankingService {
  final AppDatabase _database;

  RankingService(this._database);

  // Get all available ranks ordered by ordinal (best first)
  Future<List<Rank>> getAllRanks() {
    return (_database.select(_database.ranks)
      ..orderBy([(r) => OrderingTerm.asc(r.ordinal)]))
      .get();
  }

  // Get a specific rank by ID
  Future<Rank?> getRank(int id) {
    return (_database.select(_database.ranks)
          ..where((r) => r.id.equals(id)))
        .getSingleOrNull();
  }

  // Get default rank (Neutral / Default - ordinal 3)
  Future<Rank?> getDefaultRank() {
    return (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(3)))
        .getSingleOrNull();
  }

  // Set or update a ranking for a dancer at an event
  Future<int> setRanking({
    required int eventId,
    required int dancerId,
    required int rankId,
    String? reason,
  }) async {
    // Check if ranking already exists
    final existingRanking = await (_database.select(_database.rankings)
          ..where((r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
        .getSingleOrNull();

    if (existingRanking != null) {
      // Update existing ranking
      await _database.update(_database.rankings).replace(
        existingRanking.copyWith(
          rankId: rankId,
          reason: Value(reason),
          lastUpdated: DateTime.now(),
        ),
      );
      return existingRanking.id;
    } else {
      // Create new ranking
      return _database.into(_database.rankings).insert(
        RankingsCompanion.insert(
          eventId: eventId,
          dancerId: dancerId,
          rankId: rankId,
          reason: Value(reason),
        ),
      );
    }
  }

  // Get ranking for a specific dancer at an event
  Future<Ranking?> getRanking(int eventId, int dancerId) {
    return (_database.select(_database.rankings)
          ..where((r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
        .getSingleOrNull();
  }

  // Get all rankings for an event with dancer and rank info
  Future<List<RankingWithInfo>> getRankingsForEvent(int eventId) async {
    const query = '''
      SELECT 
        rk.*,
        d.name as dancer_name,
        r.name as rank_name,
        r.ordinal as rank_ordinal
      FROM rankings rk
      JOIN dancers d ON rk.dancer_id = d.id
      JOIN ranks r ON rk.rank_id = r.id
      WHERE rk.event_id = ?
      ORDER BY r.ordinal, d.name
    ''';

    final result = await _database.customSelect(
      query,
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.rankings, _database.dancers, _database.ranks},
    ).get();

    return result.map((row) => RankingWithInfo.fromRow(row.data)).toList();
  }

  // Get rankings grouped by rank for an event
  Future<Map<String, List<RankingWithInfo>>> getRankingsGroupedByRank(int eventId) async {
    final rankings = await getRankingsForEvent(eventId);
    final Map<String, List<RankingWithInfo>> grouped = {};

    for (final ranking in rankings) {
      final rankName = ranking.rankName;
      if (!grouped.containsKey(rankName)) {
        grouped[rankName] = [];
      }
      grouped[rankName]!.add(ranking);
    }

    return grouped;
  }

  // Delete a ranking
  Future<int> deleteRanking(int eventId, int dancerId) {
    return (_database.delete(_database.rankings)
          ..where((r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
        .go();
  }

  // Get rankings count for an event
  Future<int> getRankingsCountForEvent(int eventId) async {
    final result = await _database.customSelect(
      'SELECT COUNT(*) as count FROM rankings WHERE event_id = ?',
      variables: [Variable<int>(eventId)],
      readsFrom: {_database.rankings},
    ).getSingle();
    return result.data['count'] as int;
  }

  // Quick rank assignment methods
  Future<int> setRankReallyWantToDance(int eventId, int dancerId, {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(1)))
        .getSingle();
    return setRanking(eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankWouldLikeToDance(int eventId, int dancerId, {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(2)))
        .getSingle();
    return setRanking(eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankNeutral(int eventId, int dancerId, {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(3)))
        .getSingle();
    return setRanking(eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankMaybeLater(int eventId, int dancerId, {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(4)))
        .getSingle();
    return setRanking(eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankNotInterested(int eventId, int dancerId, {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(5)))
        .getSingle();
    return setRanking(eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }
}

// Helper class for rankings with additional info
class RankingWithInfo {
  final int id;
  final int eventId;
  final int dancerId;
  final int rankId;
  final String? reason;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String dancerName;
  final String rankName;
  final int rankOrdinal;

  RankingWithInfo({
    required this.id,
    required this.eventId,
    required this.dancerId,
    required this.rankId,
    this.reason,
    required this.createdAt,
    required this.lastUpdated,
    required this.dancerName,
    required this.rankName,
    required this.rankOrdinal,
  });

  factory RankingWithInfo.fromRow(Map<String, dynamic> row) {
    return RankingWithInfo(
      id: row['id'] as int,
      eventId: row['event_id'] as int,
      dancerId: row['dancer_id'] as int,
      rankId: row['rank_id'] as int,
      reason: row['reason'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      lastUpdated: DateTime.parse(row['last_updated'] as String),
      dancerName: row['dancer_name'] as String,
      rankName: row['rank_name'] as String,
      rankOrdinal: row['rank_ordinal'] as int,
    );
  }
} 