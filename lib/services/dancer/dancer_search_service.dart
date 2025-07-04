import 'package:drift/drift.dart';

import '../../database/database.dart';
import '../../utils/action_logger.dart';
import 'dancer_crud_service.dart';

class DancerSearchService {
  final AppDatabase _database;
  final DancerCrudService _crudService;

  DancerSearchService(this._database, this._crudService);

  // Search dancers by name
  Stream<List<Dancer>> searchDancers(String query) {
    ActionLogger.logServiceCall('DancerSearchService', 'searchDancers', {
      'query': query,
      'queryLength': query.length,
    });

    if (query.isEmpty) {
      return _crudService.watchAllDancers();
    }

    return (_database.select(_database.dancers)
          ..where((d) => d.name.contains(query))
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }

  // Search active dancers by name
  Stream<List<Dancer>> searchActiveDancers(String query) {
    ActionLogger.logServiceCall('DancerSearchService', 'searchActiveDancers', {
      'query': query,
      'queryLength': query.length,
    });

    if (query.isEmpty) {
      return _crudService.watchActiveDancers();
    }

    return (_database.select(_database.dancers)
          ..where((d) => d.name.contains(query) & d.isArchived.equals(false))
          ..orderBy([(d) => OrderingTerm.asc(d.name)]))
        .watch();
  }
}
