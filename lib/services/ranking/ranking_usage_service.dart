import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'ranking_models.dart';

class RankingUsageService {
  final AppDatabase _database;

  RankingUsageService(this._database);

  // Get usage statistics for a rank
  Future<int> getRankUsageCount(int rankId) async {
    final count = await (_database.selectOnly(_database.rankings)
          ..addColumns([_database.rankings.id.count()])
          ..where(_database.rankings.rankId.equals(rankId)))
        .getSingle();
    return count.read(_database.rankings.id.count()) ?? 0;
  }

  // Get all ranks with usage statistics
  Future<List<RankWithUsage>> getAllRanksWithUsage() async {
    ActionLogger.logServiceCall(
        'RankingUsageService', 'getAllRanksWithUsage', {});

    try {
      // Get all ranks including archived
      final ranks = await (_database.select(_database.ranks)
            ..orderBy([(r) => OrderingTerm.asc(r.ordinal)]))
          .get();
      final ranksWithUsage = <RankWithUsage>[];

      for (final rank in ranks) {
        final usageCount = await getRankUsageCount(rank.id);
        ranksWithUsage.add(RankWithUsage(
          rank: rank,
          usageCount: usageCount,
        ));
      }

      ActionLogger.logDbOperation('SELECT', 'ranks_with_usage', {
        'ranksCount': ranksWithUsage.length,
      });

      return ranksWithUsage;
    } catch (e) {
      ActionLogger.logError(
          'RankingUsageService.getAllRanksWithUsage', e.toString(), {});
      rethrow;
    }
  }

  // Get rankings count for an event
  Future<int> getRankingsCountForEvent(int eventId) async {
    ActionLogger.logServiceCall(
        'RankingUsageService', 'getRankingsCountForEvent', {
      'eventId': eventId,
    });

    try {
      final query = _database.selectOnly(_database.rankings)
        ..addColumns([_database.rankings.id.count()])
        ..where(_database.rankings.eventId.equals(eventId));

      final result = await query.getSingle();
      final count = result.read(_database.rankings.id.count()) ?? 0;

      ActionLogger.logDbOperation('SELECT', 'rankings_count', {
        'eventId': eventId,
        'count': count,
      });

      return count;
    } catch (e) {
      ActionLogger.logError(
          'RankingUsageService.getRankingsCountForEvent', e.toString(), {
        'eventId': eventId,
      });
      rethrow;
    }
  }
}
