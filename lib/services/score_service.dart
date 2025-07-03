import 'package:drift/drift.dart';

import '../database/database.dart';
import '../utils/action_logger.dart';

class ScoreService {
  final AppDatabase _database;

  ScoreService(this._database);

  // Get all available scores ordered by ordinal (best first)
  Future<List<Score>> getAllScores() {
    return (_database.select(_database.scores)..orderBy([(s) => OrderingTerm.asc(s.ordinal)])).get();
  }

  // Get a specific score by ID
  Future<Score?> getScore(int id) {
    return (_database.select(_database.scores)..where((s) => s.id.equals(id))).getSingleOrNull();
  }

  // Get all non-archived scores for use in score dropdowns
  Future<List<Score>> getActiveScores() {
    return (_database.select(_database.scores)
          ..where((s) => s.isArchived.equals(false))
          ..orderBy([(s) => OrderingTerm.asc(s.ordinal)]))
        .get();
  }

  // Get score by name (for imports)
  Future<Score?> getScoreByName(String name) {
    return (_database.select(_database.scores)..where((s) => s.name.equals(name.trim()))).getSingleOrNull();
  }

  // Create a new score
  Future<int> createScore({
    required String name,
    required int ordinal,
    bool isArchived = false,
  }) async {
    ActionLogger.logServiceCall('ScoreService', 'createScore', {
      'name': name,
      'ordinal': ordinal,
      'isArchived': isArchived,
    });

    try {
      final id = await _database.into(_database.scores).insert(
            ScoresCompanion.insert(
              name: name.trim(),
              ordinal: ordinal,
              isArchived: Value(isArchived),
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'scores', {
        'id': id,
        'name': name.trim(),
        'ordinal': ordinal,
        'isArchived': isArchived,
        'success': true,
      });

      return id;
    } catch (e) {
      ActionLogger.logError('ScoreService.createScore', e.toString(), {
        'name': name,
        'ordinal': ordinal,
        'isArchived': isArchived,
      });
      rethrow;
    }
  }

  // Update a score
  Future<bool> updateScore({
    required int id,
    String? name,
    int? ordinal,
    bool? isArchived,
  }) async {
    ActionLogger.logServiceCall('ScoreService', 'updateScore', {
      'id': id,
      'name': name,
      'ordinal': ordinal,
      'isArchived': isArchived,
    });

    try {
      final existing = await getScore(id);
      if (existing == null) {
        ActionLogger.logError('ScoreService.updateScore', 'score_not_found', {
          'id': id,
        });
        return false;
      }

      final result = await _database.update(_database.scores).replace(
            existing.copyWith(
              name: name?.trim() ?? existing.name,
              ordinal: ordinal ?? existing.ordinal,
              isArchived: isArchived ?? existing.isArchived,
              updatedAt: DateTime.now(),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'scores', {
        'id': id,
        'name': name,
        'ordinal': ordinal,
        'isArchived': isArchived,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('ScoreService.updateScore', e.toString(), {
        'id': id,
        'name': name,
        'ordinal': ordinal,
        'isArchived': isArchived,
      });
      return false;
    }
  }

  // Archive a score (hide from new events but keep in past events)
  Future<bool> archiveScore(int id) async {
    ActionLogger.logServiceCall('ScoreService', 'archiveScore', {
      'id': id,
    });

    return await updateScore(id: id, isArchived: true);
  }

  // Unarchive a score
  Future<bool> unarchiveScore(int id) async {
    ActionLogger.logServiceCall('ScoreService', 'unarchiveScore', {
      'id': id,
    });

    return await updateScore(id: id, isArchived: false);
  }

  // Delete a score (with reassignment of existing score assignments)
  Future<bool> deleteScore({
    required int id,
    required int replacementScoreId,
  }) async {
    ActionLogger.logServiceCall('ScoreService', 'deleteScore', {
      'id': id,
      'replacementScoreId': replacementScoreId,
    });

    try {
      // First, get all attendances that need to be reassigned
      final attendancesToUpdate =
          await (_database.select(_database.attendances)..where((a) => a.scoreId.equals(id))).get();

      // Start a transaction for atomic operation
      await _database.transaction(() async {
        // Reassign all existing score assignments to the replacement score
        for (final attendance in attendancesToUpdate) {
          await (_database.update(_database.attendances)..where((a) => a.id.equals(attendance.id)))
              .write(AttendancesCompanion(
            scoreId: Value(replacementScoreId),
          ));
        }

        // Delete the score
        await (_database.delete(_database.scores)..where((s) => s.id.equals(id))).go();
      });

      ActionLogger.logDbOperation('DELETE', 'scores', {
        'id': id,
        'replacementScoreId': replacementScoreId,
        'attendancesReassigned': attendancesToUpdate.length,
        'success': true,
      });

      return true;
    } catch (e) {
      ActionLogger.logError('ScoreService.deleteScore', e.toString(), {
        'id': id,
        'replacementScoreId': replacementScoreId,
      });
      return false;
    }
  }

  // Get usage statistics for a score
  Future<int> getScoreUsageCount(int scoreId) async {
    final count = await (_database.selectOnly(_database.attendances)
          ..addColumns([_database.attendances.id.count()])
          ..where(_database.attendances.scoreId.equals(scoreId)))
        .getSingle();
    return count.read(_database.attendances.id.count()) ?? 0;
  }

  // Get all scores with usage statistics
  Future<List<ScoreWithUsage>> getAllScoresWithUsage() async {
    final scores = await getActiveScores(); // Only get non-archived scores
    final scoresWithUsage = <ScoreWithUsage>[];

    for (final score in scores) {
      final usageCount = await getScoreUsageCount(score.id);
      scoresWithUsage.add(ScoreWithUsage(
        score: score,
        usageCount: usageCount,
      ));
    }

    return scoresWithUsage;
  }

  // Merge source score into target score
  Future<bool> mergeScores({
    required int sourceScoreId,
    required int targetScoreId,
  }) async {
    ActionLogger.logServiceCall('ScoreService', 'mergeScores', {
      'sourceScoreId': sourceScoreId,
      'targetScoreId': targetScoreId,
    });

    try {
      // Get all attendances that need to be reassigned
      final attendancesToUpdate =
          await (_database.select(_database.attendances)..where((a) => a.scoreId.equals(sourceScoreId))).get();

      // Start a transaction for atomic operation
      await _database.transaction(() async {
        // Reassign all existing score assignments to the target score
        for (final attendance in attendancesToUpdate) {
          await (_database.update(_database.attendances)..where((a) => a.id.equals(attendance.id)))
              .write(AttendancesCompanion(
            scoreId: Value(targetScoreId),
          ));
        }

        // Delete the source score
        await (_database.delete(_database.scores)..where((s) => s.id.equals(sourceScoreId))).go();
      });

      ActionLogger.logDbOperation('MERGE', 'scores', {
        'sourceScoreId': sourceScoreId,
        'targetScoreId': targetScoreId,
        'attendancesReassigned': attendancesToUpdate.length,
        'success': true,
      });

      return true;
    } catch (e) {
      ActionLogger.logError('ScoreService.mergeScores', e.toString(), {
        'sourceScoreId': sourceScoreId,
        'targetScoreId': targetScoreId,
      });
      return false;
    }
  }

  // Update ordinals for multiple scores (for reordering)
  Future<bool> updateScoreOrder(List<ScoreOrderUpdate> updates) async {
    ActionLogger.logServiceCall('ScoreService', 'updateScoreOrder', {
      'updates': updates.map((u) => {'id': u.id, 'ordinal': u.ordinal}).toList(),
    });

    try {
      await _database.transaction(() async {
        for (final update in updates) {
          await updateScore(id: update.id, ordinal: update.ordinal);
        }
      });

      ActionLogger.logDbOperation('UPDATE_ORDER', 'scores', {
        'updatesCount': updates.length,
        'success': true,
      });

      return true;
    } catch (e) {
      ActionLogger.logError('ScoreService.updateScoreOrder', e.toString(), {
        'updates': updates.map((u) => {'id': u.id, 'ordinal': u.ordinal}).toList(),
      });
      return false;
    }
  }
}

// Helper class for score with usage statistics
class ScoreWithUsage {
  final Score score;
  final int usageCount;

  ScoreWithUsage({
    required this.score,
    required this.usageCount,
  });
}

// Helper class for score reordering
class ScoreOrderUpdate {
  final int id;
  final int ordinal;

  ScoreOrderUpdate({
    required this.id,
    required this.ordinal,
  });
}
