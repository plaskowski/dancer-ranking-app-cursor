import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'ranking_models.dart';

class RankingOperationsService {
  final AppDatabase _database;

  RankingOperationsService(this._database);

  // Set a ranking for a dancer at an event
  Future<int> setRanking({
    required int eventId,
    required int dancerId,
    required int rankId,
    String? reason,
  }) async {
    ActionLogger.logServiceCall('RankingOperationsService', 'setRanking', {
      'eventId': eventId,
      'dancerId': dancerId,
      'rankId': rankId,
      'hasReason': reason != null,
    });

    try {
      // Check if ranking already exists
      final existing = await (_database.select(_database.rankings)
            ..where(
                (r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
          .getSingleOrNull();

      int id;
      if (existing != null) {
        // Update existing ranking
        await _database.update(_database.rankings).replace(
              existing.copyWith(
                rankId: rankId,
                reason: Value(reason),
                lastUpdated: DateTime.now(),
              ),
            );
        id = existing.id;

        ActionLogger.logDbOperation('UPDATE', 'rankings', {
          'id': id,
          'eventId': eventId,
          'dancerId': dancerId,
          'rankId': rankId,
          'reason': reason,
        });
      } else {
        // Create new ranking
        id = await _database.into(_database.rankings).insert(
              RankingsCompanion.insert(
                eventId: eventId,
                dancerId: dancerId,
                rankId: rankId,
                reason: Value(reason),
              ),
            );

        ActionLogger.logDbOperation('INSERT', 'rankings', {
          'id': id,
          'eventId': eventId,
          'dancerId': dancerId,
          'rankId': rankId,
          'reason': reason,
        });
      }

      return id;
    } catch (e) {
      ActionLogger.logError(
          'RankingOperationsService.setRanking', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
        'rankId': rankId,
      });
      rethrow;
    }
  }

  // Get ranking for a specific dancer at an event
  Future<Ranking?> getRanking(int eventId, int dancerId) {
    ActionLogger.logServiceCall('RankingOperationsService', 'getRanking', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    return (_database.select(_database.rankings)
          ..where(
              (r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
        .getSingleOrNull();
  }

  // Get all rankings for an event with dancer and rank info
  Future<List<RankingWithInfo>> getRankingsForEvent(int eventId) async {
    ActionLogger.logServiceCall(
        'RankingOperationsService', 'getRankingsForEvent', {
      'eventId': eventId,
    });

    try {
      final query = _database.select(_database.rankings).join([
        innerJoin(_database.dancers,
            _database.dancers.id.equalsExp(_database.rankings.dancerId)),
        innerJoin(_database.ranks,
            _database.ranks.id.equalsExp(_database.rankings.rankId)),
      ])
        ..where(_database.rankings.eventId.equals(eventId))
        ..orderBy([
          OrderingTerm(expression: _database.ranks.ordinal),
          OrderingTerm(expression: _database.dancers.name),
        ]);

      final results = await query.get();

      final rankingsWithInfo = results.map((row) {
        final ranking = row.readTable(_database.rankings);
        final dancer = row.readTable(_database.dancers);
        final rank = row.readTable(_database.ranks);

        return RankingWithInfo(
          id: ranking.id,
          eventId: ranking.eventId,
          dancerId: ranking.dancerId,
          rankId: ranking.rankId,
          reason: ranking.reason,
          createdAt: ranking.createdAt,
          lastUpdated: ranking.lastUpdated,
          dancerName: dancer.name,
          rankName: rank.name,
          rankOrdinal: rank.ordinal,
        );
      }).toList();

      ActionLogger.logDbOperation('SELECT', 'rankings_with_info', {
        'eventId': eventId,
        'resultCount': rankingsWithInfo.length,
      });

      return rankingsWithInfo;
    } catch (e) {
      ActionLogger.logError(
          'RankingOperationsService.getRankingsForEvent', e.toString(), {
        'eventId': eventId,
      });
      rethrow;
    }
  }

  // Get rankings grouped by rank for an event
  Future<Map<String, List<RankingWithInfo>>> getRankingsGroupedByRank(
      int eventId) async {
    ActionLogger.logServiceCall(
        'RankingOperationsService', 'getRankingsGroupedByRank', {
      'eventId': eventId,
    });

    final rankings = await getRankingsForEvent(eventId);
    final Map<String, List<RankingWithInfo>> grouped = {};

    for (final ranking in rankings) {
      final rankName = ranking.rankName;
      if (!grouped.containsKey(rankName)) {
        grouped[rankName] = [];
      }
      grouped[rankName]!.add(ranking);
    }

    ActionLogger.logAction('RankingOperationsService.getRankingsGroupedByRank',
        'grouped_rankings', {
      'eventId': eventId,
      'groupsCount': grouped.length,
      'totalRankings': rankings.length,
    });

    return grouped;
  }

  // Delete a ranking
  Future<int> deleteRanking(int eventId, int dancerId) async {
    ActionLogger.logServiceCall('RankingOperationsService', 'deleteRanking', {
      'eventId': eventId,
      'dancerId': dancerId,
    });

    try {
      final result = await (_database.delete(_database.rankings)
            ..where(
                (r) => r.eventId.equals(eventId) & r.dancerId.equals(dancerId)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'rankings', {
        'eventId': eventId,
        'dancerId': dancerId,
        'affected_rows': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'RankingOperationsService.deleteRanking', e.toString(), {
        'eventId': eventId,
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Quick rank assignment methods
  Future<int> setRankReallyWantToDance(int eventId, int dancerId,
      {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(1)))
        .getSingle();
    return setRanking(
        eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankWouldLikeToDance(int eventId, int dancerId,
      {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(2)))
        .getSingle();
    return setRanking(
        eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankNeutral(int eventId, int dancerId,
      {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(3)))
        .getSingle();
    return setRanking(
        eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankMaybeLater(int eventId, int dancerId,
      {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(4)))
        .getSingle();
    return setRanking(
        eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }

  Future<int> setRankNotInterested(int eventId, int dancerId,
      {String? reason}) async {
    final rank = await (_database.select(_database.ranks)
          ..where((r) => r.ordinal.equals(5)))
        .getSingle();
    return setRanking(
        eventId: eventId, dancerId: dancerId, rankId: rank.id, reason: reason);
  }
}
