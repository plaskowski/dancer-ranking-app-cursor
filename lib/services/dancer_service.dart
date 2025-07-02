import '../database/database.dart';
import '../models/dancer_with_tags.dart';
import 'dancer/dancer_crud_service.dart';
import 'dancer/dancer_event_service.dart';
import 'dancer/dancer_merge_service.dart';
import 'dancer/dancer_models.dart';
import 'dancer/dancer_search_service.dart';
import 'dancer/dancer_tag_service.dart';

// Re-export models for backward compatibility
export 'dancer/dancer_models.dart';

class DancerService {
  final AppDatabase _database;
  late final DancerCrudService _crudService;
  late final DancerSearchService _searchService;
  late final DancerTagService _tagService;
  late final DancerMergeService _mergeService;
  late final DancerEventService _eventService;

  DancerService(this._database) {
    _crudService = DancerCrudService(_database);
    _searchService = DancerSearchService(_database, _crudService);
    _tagService = DancerTagService(_database, _crudService);
    _mergeService = DancerMergeService(_database, _crudService);
    _eventService = DancerEventService(_database);
  }

  // CRUD Methods
  Stream<List<Dancer>> watchAllDancers() => _crudService.watchAllDancers();

  Future<Dancer?> getDancer(int id) => _crudService.getDancer(id);

  Future<int> createDancer({required String name, String? notes}) =>
      _crudService.createDancer(name: name, notes: notes);

  Future<bool> updateDancer(int id, {String? name, String? notes}) =>
      _crudService.updateDancer(id, name: name, notes: notes);

  Future<bool> updateFirstMetDate(int id, DateTime? firstMetDate) =>
      _crudService.updateFirstMetDate(id, firstMetDate);

  Future<int> deleteDancer(int id) => _crudService.deleteDancer(id);

  Future<int> getDancersCount() => _crudService.getDancersCount();

  // Search Methods
  Stream<List<Dancer>> searchDancers(String query) =>
      _searchService.searchDancers(query);

  // Tag Methods
  Future<List<DancerWithTags>> getDancersWithTags() =>
      _tagService.getDancersWithTags();

  Stream<List<DancerWithTags>> watchDancersWithTags() =>
      _tagService.watchDancersWithTags();

  // Event Methods
  Stream<List<DancerWithEventInfo>> watchDancersForEvent(int eventId) =>
      _eventService.watchDancersForEvent(eventId);

  Future<List<DancerWithEventInfo>> getUnrankedDancersForEvent(int eventId) =>
      _eventService.getUnrankedDancersForEvent(eventId);

  // Merge Methods
  Future<bool> mergeDancers(int sourceDancerId, int targetDancerId) =>
      _mergeService.mergeDancers(sourceDancerId, targetDancerId);
}
