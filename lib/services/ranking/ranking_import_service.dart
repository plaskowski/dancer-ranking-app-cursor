import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'ranking_models.dart';
import 'ranking_operations_service.dart';

class RankingImportService {
  final AppDatabase _database;
  final RankingOperationsService _operationsService;

  RankingImportService(this._database, this._operationsService);

  // Import rankings from another event
  Future<ImportRankingsResult> importRankingsFromEvent({
    required int sourceEventId,
    required int targetEventId,
    bool overwriteExisting = false,
  }) async {
    ActionLogger.logServiceCall(
        'RankingImportService', 'importRankingsFromEvent', {
      'sourceEventId': sourceEventId,
      'targetEventId': targetEventId,
      'overwriteExisting': overwriteExisting,
    });

    try {
      // Get all rankings from source event
      final sourceRankings = await (_database.select(_database.rankings)
            ..where((r) => r.eventId.equals(sourceEventId)))
          .get();

      if (sourceRankings.isEmpty) {
        ActionLogger.logAction('RankingImportService.importRankingsFromEvent',
            'no_source_rankings', {
          'sourceEventId': sourceEventId,
          'targetEventId': targetEventId,
        });
        return ImportRankingsResult(
          imported: 0,
          skipped: 0,
          overwritten: 0,
          sourceRankingsCount: 0,
        );
      }

      // Get existing rankings in target event
      final existingRankings = await (_database.select(_database.rankings)
            ..where((r) => r.eventId.equals(targetEventId)))
          .get();

      final existingDancerIds = existingRankings.map((r) => r.dancerId).toSet();

      int imported = 0;
      int skipped = 0;
      int overwritten = 0;

      // Process each source ranking
      for (final sourceRanking in sourceRankings) {
        final dancerId = sourceRanking.dancerId;

        if (existingDancerIds.contains(dancerId)) {
          if (overwriteExisting) {
            // Update existing ranking
            await _operationsService.setRanking(
              eventId: targetEventId,
              dancerId: dancerId,
              rankId: sourceRanking.rankId,
              reason: sourceRanking.reason,
            );
            overwritten++;
            ActionLogger.logAction(
                'RankingImportService.importRankingsFromEvent',
                'ranking_overwritten', {
              'sourceEventId': sourceEventId,
              'targetEventId': targetEventId,
              'dancerId': dancerId,
              'rankId': sourceRanking.rankId,
            });
          } else {
            // Skip existing ranking
            skipped++;
            ActionLogger.logAction(
                'RankingImportService.importRankingsFromEvent',
                'ranking_skipped', {
              'sourceEventId': sourceEventId,
              'targetEventId': targetEventId,
              'dancerId': dancerId,
              'reason': 'already_exists',
            });
          }
        } else {
          // Create new ranking
          await _operationsService.setRanking(
            eventId: targetEventId,
            dancerId: dancerId,
            rankId: sourceRanking.rankId,
            reason: sourceRanking.reason,
          );
          imported++;
          ActionLogger.logAction('RankingImportService.importRankingsFromEvent',
              'ranking_imported', {
            'sourceEventId': sourceEventId,
            'targetEventId': targetEventId,
            'dancerId': dancerId,
            'rankId': sourceRanking.rankId,
          });
        }
      }

      final result = ImportRankingsResult(
        imported: imported,
        skipped: skipped,
        overwritten: overwritten,
        sourceRankingsCount: sourceRankings.length,
      );

      ActionLogger.logAction(
          'RankingImportService.importRankingsFromEvent', 'import_completed', {
        'sourceEventId': sourceEventId,
        'targetEventId': targetEventId,
        'imported': imported,
        'skipped': skipped,
        'overwritten': overwritten,
        'sourceRankingsCount': sourceRankings.length,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'RankingImportService.importRankingsFromEvent', e.toString(), {
        'sourceEventId': sourceEventId,
        'targetEventId': targetEventId,
      });
      rethrow;
    }
  }
}
