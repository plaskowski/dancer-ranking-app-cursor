import 'package:drift/drift.dart';

import '../database/database.dart';
import '../utils/action_logger.dart';

class ScoreService {
  final AppDatabase _database;

  ScoreService(this._database);

  // Get all available scores ordered by ordinal (best first)
  Future<List<Score>> getAllScores() {
    return (_database.select(_database.scores)
          ..orderBy([(s) => OrderingTerm.asc(s.ordinal)]))
        .get();
  }

  // Get a specific score by ID
  Future<Score?> getScore(int id) {
    return (_database.select(_database.scores)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  // Get default score (Good - ordinal 3)
  Future<Score?> getDefaultScore() {
    return (_database.select(_database.scores)
          ..where((s) => s.ordinal.equals(3)))
        .getSingleOrNull();
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
    return (_database.select(_database.scores)
          ..where((s) => s.name.equals(name.trim())))
        .getSingleOrNull();
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
      final attendancesToUpdate = await (_database.select(_database.attendances)
            ..where((a) => a.scoreId.equals(id)))
          .get();

      // Start a transaction for atomic operation
      await _database.transaction(() async {
        // Reassign all existing score assignments to the replacement score
        for (final attendance in attendancesToUpdate) {
          await (_database.update(_database.attendances)
                ..where((a) => a.id.equals(attendance.id)))
              .write(AttendancesCompanion(
            scoreId: Value(replacementScoreId),
          ));
        }

        // Delete the score
        await (_database.delete(_database.scores)
              ..where((s) => s.id.equals(id)))
            .go();
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
}
