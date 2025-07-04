import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';

class DancerCrudService {
  final AppDatabase _database;

  DancerCrudService(this._database);

  // Get all dancers ordered by name
  Stream<List<Dancer>> watchAllDancers() {
    ActionLogger.logServiceCall('DancerCrudService', 'watchAllDancers');

    return (_database.select(_database.dancers)
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Get active dancers ordered by name
  Stream<List<Dancer>> watchActiveDancers() {
    ActionLogger.logServiceCall('DancerCrudService', 'watchActiveDancers');

    return (_database.select(_database.dancers)
          ..where((d) => d.isArchived.equals(false))
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Get a specific dancer by ID
  Future<Dancer?> getDancer(int id) {
    ActionLogger.logServiceCall(
        'DancerCrudService', 'getDancer', {'dancerId': id});

    return (_database.select(_database.dancers)..where((d) => d.id.equals(id)))
        .getSingleOrNull();
  }

  // Create a new dancer
  Future<int> createDancer({required String name, String? notes}) async {
    ActionLogger.logServiceCall('DancerCrudService', 'createDancer', {
      'name': name,
      'hasNotes': notes != null,
    });

    try {
      final id = await _database.into(_database.dancers).insert(
            DancersCompanion.insert(
              name: name,
              notes: Value(notes),
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'dancers', {
        'id': id,
        'name': name,
        'notes': notes,
      });

      return id;
    } catch (e) {
      ActionLogger.logError('DancerCrudService.createDancer', e.toString(), {
        'name': name,
        'hasNotes': notes != null,
      });
      rethrow;
    }
  }

  // Update an existing dancer
  Future<bool> updateDancer(int id, {String? name, String? notes}) async {
    ActionLogger.logServiceCall('DancerCrudService', 'updateDancer', {
      'dancerId': id,
      'hasName': name != null,
      'hasNotes': notes != null,
    });

    try {
      final dancer = await getDancer(id);
      if (dancer == null) {
        ActionLogger.logAction(
            'DancerCrudService.updateDancer', 'dancer_not_found', {
          'dancerId': id,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              name: name ?? dancer.name,
              notes: Value(notes),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers', {
        'id': id,
        'oldName': dancer.name,
        'newName': name ?? dancer.name,
        'oldNotes': dancer.notes,
        'newNotes': notes ?? dancer.notes,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerCrudService.updateDancer', e.toString(), {
        'dancerId': id,
        'name': name,
        'notes': notes,
      });
      rethrow;
    }
  }

  // Update first met date for a dancer (for dancers met before event tracking)
  Future<bool> updateFirstMetDate(int id, DateTime? firstMetDate) async {
    ActionLogger.logServiceCall('DancerCrudService', 'updateFirstMetDate', {
      'dancerId': id,
      'firstMetDate': firstMetDate?.toIso8601String(),
    });

    try {
      final dancer = await getDancer(id);
      if (dancer == null) {
        ActionLogger.logError(
            'DancerCrudService.updateFirstMetDate', 'dancer_not_found', {
          'dancerId': id,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              firstMetDate: Value(firstMetDate),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers', {
        'id': id,
        'oldFirstMetDate': dancer.firstMetDate?.toIso8601String(),
        'newFirstMetDate': firstMetDate?.toIso8601String(),
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'DancerCrudService.updateFirstMetDate', e.toString(), {
        'dancerId': id,
        'firstMetDate': firstMetDate?.toIso8601String(),
      });
      return false;
    }
  }

  // Delete a dancer (this will cascade delete rankings and attendances)
  Future<int> deleteDancer(int id) async {
    ActionLogger.logServiceCall('DancerCrudService', 'deleteDancer', {
      'dancerId': id,
    });

    try {
      final result = await (_database.delete(_database.dancers)
            ..where((d) => d.id.equals(id)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'dancers', {
        'id': id,
        'affected_rows': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerCrudService.deleteDancer', e.toString(), {
        'dancerId': id,
      });
      rethrow;
    }
  }

  // Get dancers count
  Future<int> getDancersCount() async {
    ActionLogger.logServiceCall('DancerCrudService', 'getDancersCount');

    try {
      final countExp = countAll();
      final query = _database.selectOnly(_database.dancers)
        ..addColumns([countExp]);

      final result = await query.getSingle();
      final count = result.read(countExp)!;

      ActionLogger.logAction(
          'DancerCrudService.getDancersCount', 'count_retrieved', {
        'count': count,
      });

      return count;
    } catch (e) {
      ActionLogger.logError('DancerCrudService.getDancersCount', e.toString());
      rethrow;
    }
  }

  // Archive a dancer
  Future<bool> archiveDancer(int dancerId) async {
    ActionLogger.logServiceCall('DancerCrudService', 'archiveDancer', {
      'dancerId': dancerId,
    });

    try {
      final dancer = await getDancer(dancerId);
      if (dancer == null) {
        ActionLogger.logAction(
            'DancerCrudService.archiveDancer', 'dancer_not_found', {
          'dancerId': dancerId,
        });
        return false;
      }

      if (dancer.isArchived) {
        ActionLogger.logAction(
            'DancerCrudService.archiveDancer', 'already_archived', {
          'dancerId': dancerId,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              isArchived: true,
              archivedAt: Value(DateTime.now()),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers_archive', {
        'id': dancerId,
        'name': dancer.name,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('DancerCrudService.archiveDancer', e.toString(), {
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Reactivate a dancer
  Future<bool> reactivateDancer(int dancerId) async {
    ActionLogger.logServiceCall('DancerCrudService', 'reactivateDancer', {
      'dancerId': dancerId,
    });

    try {
      final dancer = await getDancer(dancerId);
      if (dancer == null) {
        ActionLogger.logAction(
            'DancerCrudService.reactivateDancer', 'dancer_not_found', {
          'dancerId': dancerId,
        });
        return false;
      }

      if (!dancer.isArchived) {
        ActionLogger.logAction(
            'DancerCrudService.reactivateDancer', 'already_active', {
          'dancerId': dancerId,
        });
        return false;
      }

      final result = await _database.update(_database.dancers).replace(
            dancer.copyWith(
              isArchived: false,
              archivedAt: const Value(null),
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'dancers_reactivate', {
        'id': dancerId,
        'name': dancer.name,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError(
          'DancerCrudService.reactivateDancer', e.toString(), {
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Get archived dancers
  Future<List<Dancer>> getArchivedDancers() async {
    ActionLogger.logServiceCall('DancerCrudService', 'getArchivedDancers');

    try {
      final dancers = await (_database.select(_database.dancers)
            ..where((d) => d.isArchived.equals(true))
            ..orderBy([(d) => OrderingTerm.desc(d.archivedAt)]))
          .get();

      ActionLogger.logAction(
          'DancerCrudService.getArchivedDancers', 'archived_retrieved', {
        'count': dancers.length,
      });

      return dancers;
    } catch (e) {
      ActionLogger.logError(
          'DancerCrudService.getArchivedDancers', e.toString());
      rethrow;
    }
  }
}
