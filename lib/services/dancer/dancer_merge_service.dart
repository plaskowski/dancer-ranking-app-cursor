import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'dancer_crud_service.dart';

class DancerMergeService {
  final AppDatabase _database;
  final DancerCrudService _crudService;

  DancerMergeService(this._database, this._crudService);

  // Merge one dancer into another
  Future<bool> mergeDancers(int sourceDancerId, int targetDancerId) async {
    ActionLogger.logUserAction('DancerMergeService', 'mergeDancers', {
      'sourceDancerId': sourceDancerId,
      'targetDancerId': targetDancerId,
    });

    return await _database.transaction(() async {
      try {
        // 1. Get source and target dancer data
        final sourceDancer = await _crudService.getDancer(sourceDancerId);
        final targetDancer = await _crudService.getDancer(targetDancerId);

        if (sourceDancer == null || targetDancer == null) {
          return false;
        }

        // 2. Update all foreign key references to point to target dancer

        // Update rankings
        await _database.customUpdate(
          'UPDATE rankings SET dancer_id = ? WHERE dancer_id = ?',
          variables: [
            Variable.withInt(targetDancerId),
            Variable.withInt(sourceDancerId)
          ],
        );

        // Update attendances (handle duplicates by keeping target's record)
        await _database.customUpdate(
          '''UPDATE attendances SET dancer_id = ? 
             WHERE dancer_id = ? 
             AND NOT EXISTS (
               SELECT 1 FROM attendances a2 
               WHERE a2.dancer_id = ? AND a2.event_id = attendances.event_id
             )''',
          variables: [
            Variable.withInt(targetDancerId),
            Variable.withInt(sourceDancerId),
            Variable.withInt(targetDancerId)
          ],
        );

        // Delete duplicate attendances for events where target already exists
        await _database.customUpdate(
          '''DELETE FROM attendances 
             WHERE dancer_id = ? 
             AND EXISTS (
               SELECT 1 FROM attendances a2 
               WHERE a2.dancer_id = ? AND a2.event_id = attendances.event_id
             )''',
          variables: [
            Variable.withInt(sourceDancerId),
            Variable.withInt(targetDancerId)
          ],
        );

        // Update dancer_tags (duplicates will be ignored due to unique constraint)
        await _database.customUpdate(
          '''INSERT OR IGNORE INTO dancer_tags (dancer_id, tag_id, created_at)
             SELECT ?, tag_id, created_at FROM dancer_tags WHERE dancer_id = ?''',
          variables: [
            Variable.withInt(targetDancerId),
            Variable.withInt(sourceDancerId)
          ],
        );

        // Delete source dancer's tags
        await _database.customUpdate(
          'DELETE FROM dancer_tags WHERE dancer_id = ?',
          variables: [Variable.withInt(sourceDancerId)],
        );

        // 3. Merge notes and first met date into target dancer
        String? mergedNotes;
        if (targetDancer.notes != null && sourceDancer.notes != null) {
          mergedNotes = '${targetDancer.notes} | ${sourceDancer.notes}';
        } else {
          mergedNotes = targetDancer.notes ?? sourceDancer.notes;
        }

        DateTime? earliestFirstMet;
        if (targetDancer.firstMetDate != null &&
            sourceDancer.firstMetDate != null) {
          earliestFirstMet =
              targetDancer.firstMetDate!.isBefore(sourceDancer.firstMetDate!)
                  ? targetDancer.firstMetDate
                  : sourceDancer.firstMetDate;
        } else {
          earliestFirstMet =
              targetDancer.firstMetDate ?? sourceDancer.firstMetDate;
        }

        await (_database.update(_database.dancers)
              ..where((t) => t.id.equals(targetDancerId)))
            .write(DancersCompanion(
          notes: Value(mergedNotes),
          firstMetDate: Value(earliestFirstMet),
        ));

        // 4. Delete source dancer
        await (_database.delete(_database.dancers)
              ..where((t) => t.id.equals(sourceDancerId)))
            .go();

        ActionLogger.logUserAction(
            'DancerMergeService', 'mergeDancers_success', {
          'sourceDancerId': sourceDancerId,
          'targetDancerId': targetDancerId,
          'mergedNotes': mergedNotes != null,
          'mergedFirstMet': earliestFirstMet != null,
        });

        return true;
      } catch (e) {
        ActionLogger.logError('DancerMergeService', 'mergeDancers_failed', {
          'sourceDancerId': sourceDancerId,
          'targetDancerId': targetDancerId,
          'error': e.toString(),
        });
        return false;
      }
    });
  }
}
