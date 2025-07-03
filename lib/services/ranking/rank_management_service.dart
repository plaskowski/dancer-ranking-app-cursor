import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';

class RankManagementService {
  final AppDatabase _database;

  RankManagementService(this._database);

  // Get all available ranks ordered by ordinal (best first)
  Future<List<Rank>> getAllRanks() {
    ActionLogger.logServiceCall('RankManagementService', 'getAllRanks', {});
    return (_database.select(_database.ranks)..orderBy([(r) => OrderingTerm.asc(r.ordinal)])).get();
  }

  // Get a specific rank by ID
  Future<Rank?> getRank(int id) {
    ActionLogger.logServiceCall('RankManagementService', 'getRank', {'id': id});
    return (_database.select(_database.ranks)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  // Get all non-archived ranks for use in ranking dropdowns
  Future<List<Rank>> getActiveRanks() {
    ActionLogger.logServiceCall('RankManagementService', 'getActiveRanks', {});
    return (_database.select(_database.ranks)
          ..where((r) => r.isArchived.equals(false))
          ..orderBy([(r) => OrderingTerm.asc(r.ordinal)]))
        .get();
  }

  // Create a new rank
  Future<int> createRank({
    required String name,
    required int ordinal,
  }) async {
    ActionLogger.logServiceCall('RankManagementService', 'createRank', {
      'name': name,
      'ordinal': ordinal,
    });

    try {
      final id = await _database.into(_database.ranks).insert(
            RanksCompanion.insert(
              name: name,
              ordinal: ordinal,
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'ranks', {
        'id': id,
        'name': name,
        'ordinal': ordinal,
      });

      return id;
    } catch (e) {
      ActionLogger.logError('RankManagementService.createRank', e.toString(), {
        'name': name,
        'ordinal': ordinal,
      });
      rethrow;
    }
  }

  // Update a rank
  Future<bool> updateRank({
    required int id,
    String? name,
    int? ordinal,
    bool? isArchived,
  }) async {
    ActionLogger.logServiceCall('RankManagementService', 'updateRank', {
      'id': id,
      'hasName': name != null,
      'hasOrdinal': ordinal != null,
      'hasIsArchived': isArchived != null,
    });

    try {
      final existing = await getRank(id);
      if (existing == null) {
        ActionLogger.logError('RankManagementService.updateRank', 'rank_not_found', {
          'id': id,
        });
        return false;
      }

      final result = await _database.update(_database.ranks).replace(
            existing.copyWith(
              name: name ?? existing.name,
              ordinal: ordinal ?? existing.ordinal,
              isArchived: isArchived ?? existing.isArchived,
              updatedAt: DateTime.now(),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'ranks', {
        'id': id,
        'name': name,
        'ordinal': ordinal,
        'isArchived': isArchived,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('RankManagementService.updateRank', e.toString(), {
        'id': id,
      });
      rethrow;
    }
  }

  // Archive a rank (hide from new events but keep in past events)
  Future<bool> archiveRank(int id) async {
    ActionLogger.logServiceCall('RankManagementService', 'archiveRank', {
      'id': id,
    });

    return await updateRank(id: id, isArchived: true);
  }

  // Unarchive a rank
  Future<bool> unarchiveRank(int id) async {
    ActionLogger.logServiceCall('RankManagementService', 'unarchiveRank', {
      'id': id,
    });

    return await updateRank(id: id, isArchived: false);
  }

  // Delete a rank (with reassignment of existing rankings)
  Future<bool> deleteRank({
    required int id,
    required int replacementRankId,
  }) async {
    ActionLogger.logServiceCall('RankManagementService', 'deleteRank', {
      'id': id,
      'replacementRankId': replacementRankId,
    });

    try {
      await _database.transaction(() async {
        // First, get all rankings that need to be reassigned
        final rankingsToUpdate = await (_database.select(_database.rankings)..where((r) => r.rankId.equals(id))).get();

        // Reassign all existing rankings to the replacement rank
        int updateResult = 0;
        for (final ranking in rankingsToUpdate) {
          await _database.update(_database.rankings).replace(
                ranking.copyWith(
                  rankId: replacementRankId,
                  lastUpdated: DateTime.now(),
                ),
              );
          updateResult++;
        }

        ActionLogger.logDbOperation('UPDATE', 'rankings', {
          'reassigned_from_rank': id,
          'reassigned_to_rank': replacementRankId,
          'affected_rows': updateResult,
        });

        // Then delete the rank
        final deleteResult = await (_database.delete(_database.ranks)..where((r) => r.id.equals(id))).go();

        ActionLogger.logDbOperation('DELETE', 'ranks', {
          'id': id,
          'affected_rows': deleteResult,
        });

        if (deleteResult == 0) {
          throw Exception('Rank not found');
        }
      });

      return true;
    } catch (e) {
      ActionLogger.logError('RankManagementService.deleteRank', e.toString(), {
        'id': id,
        'replacementRankId': replacementRankId,
      });
      rethrow;
    }
  }

  // Update rank ordinals after reordering
  Future<bool> updateRankOrdinals(List<Rank> ranks) async {
    ActionLogger.logServiceCall('RankManagementService', 'updateRankOrdinals', {
      'ranksCount': ranks.length,
    });

    try {
      await _database.transaction(() async {
        for (int i = 0; i < ranks.length; i++) {
          final rank = ranks[i];
          final newOrdinal = i + 1;

          if (rank.ordinal != newOrdinal) {
            await _database.update(_database.ranks).replace(
                  rank.copyWith(
                    ordinal: newOrdinal,
                    updatedAt: DateTime.now(),
                  ),
                );

            ActionLogger.logDbOperation('UPDATE', 'ranks', {
              'id': rank.id,
              'oldOrdinal': rank.ordinal,
              'newOrdinal': newOrdinal,
            });
          }
        }
      });

      ActionLogger.logAction('RankManagementService.updateRankOrdinals', 'ordinals_updated', {
        'ranksCount': ranks.length,
      });

      return true;
    } catch (e) {
      ActionLogger.logError('RankManagementService.updateRankOrdinals', e.toString(), {
        'ranksCount': ranks.length,
      });
      rethrow;
    }
  }
}
