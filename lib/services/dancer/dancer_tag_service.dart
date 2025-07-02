import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../models/dancer_with_tags.dart';
import '../../utils/action_logger.dart';
import 'dancer_crud_service.dart';

class DancerTagService {
  final AppDatabase _database;
  final DancerCrudService _crudService;

  DancerTagService(this._database, this._crudService);

  // Get dancers with their tags for display
  Future<List<DancerWithTags>> getDancersWithTags() async {
    ActionLogger.logServiceCall('DancerTagService', 'getDancersWithTags');

    try {
      final dancers = await (_database.select(_database.dancers)
            ..orderBy([(d) => OrderingTerm.asc(d.name)]))
          .get();

      final dancersWithTags = <DancerWithTags>[];

      for (final dancer in dancers) {
        // Get tags for this dancer
        final tagQuery = _database.select(_database.tags).join([
          innerJoin(
            _database.dancerTags,
            _database.tags.id.equalsExp(_database.dancerTags.tagId),
          ),
        ])
          ..where(_database.dancerTags.dancerId.equals(dancer.id))
          ..orderBy([OrderingTerm.asc(_database.tags.name)]);

        final tagResults = await tagQuery.get();
        final tags =
            tagResults.map((row) => row.readTable(_database.tags)).toList();

        dancersWithTags.add(DancerWithTags(
          dancer: dancer,
          tags: tags,
        ));
      }

      return dancersWithTags;
    } catch (e) {
      ActionLogger.logError(
          'DancerTagService.getDancersWithTags', e.toString());
      rethrow;
    }
  }

  // Watch dancers with their tags for reactive updates
  Stream<List<DancerWithTags>> watchDancersWithTags() {
    ActionLogger.logServiceCall('DancerTagService', 'watchDancersWithTags');

    // Use the existing watchAllDancers stream and transform it
    return _crudService.watchAllDancers().asyncMap((_) async {
      return await getDancersWithTags();
    });
  }
}
