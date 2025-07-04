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

  Stream<List<Dancer>> watchActiveDancers() =>
      _crudService.watchActiveDancers();

  Future<Dancer?> getDancer(int id) => _crudService.getDancer(id);

  Future<int> createDancer({required String name, String? notes}) =>
      _crudService.createDancer(name: name, notes: notes);

  Future<bool> updateDancer(int id, {String? name, String? notes}) =>
      _crudService.updateDancer(id, name: name, notes: notes);

  Future<bool> updateFirstMetDate(int id, DateTime? firstMetDate) =>
      _crudService.updateFirstMetDate(id, firstMetDate);

  Future<int> deleteDancer(int id) => _crudService.deleteDancer(id);

  Future<int> getDancersCount() => _crudService.getDancersCount();

  // Archival Methods
  Future<bool> archiveDancer(int dancerId) =>
      _crudService.archiveDancer(dancerId);

  Future<bool> reactivateDancer(int dancerId) =>
      _crudService.reactivateDancer(dancerId);

  Future<List<Dancer>> getArchivedDancers() =>
      _crudService.getArchivedDancers();

  // Search Methods
  Stream<List<Dancer>> searchDancers(String query) =>
      _searchService.searchDancers(query);

  Stream<List<Dancer>> searchActiveDancers(String query) =>
      _searchService.searchActiveDancers(query);

  // Tag Methods
  Future<List<DancerWithTags>> getDancersWithTags() =>
      _tagService.getDancersWithTags();

  Stream<List<DancerWithTags>> watchDancersWithTags() =>
      _tagService.watchDancersWithTags();

  Future<List<DancerWithTags>> getActiveDancersWithTags() =>
      _tagService.getActiveDancersWithTags();

  Stream<List<DancerWithTags>> watchActiveDancersWithTags() =>
      _tagService.watchActiveDancersWithTags();

  Stream<List<DancerWithTags>> watchArchivedDancersWithTags() =>
      _tagService.watchArchivedDancersWithTags();

  Future<List<DancerWithTags>> getDancersWithTagsAndLastMet() =>
      _tagService.getDancersWithTagsAndLastMet();

  Stream<List<DancerWithTags>> watchDancersWithTagsAndLastMet() =>
      _tagService.watchDancersWithTagsAndLastMet();

  // Event Methods
  Stream<List<DancerWithEventInfo>> watchDancersForEvent(int eventId) =>
      _eventService.watchDancersForEvent(eventId);

  Future<List<DancerWithEventInfo>> getUnrankedDancersForEvent(int eventId) =>
      _eventService.getUnrankedDancersForEvent(eventId);

  // Merge Methods
  Future<bool> mergeDancers(int sourceDancerId, int targetDancerId) =>
      _mergeService.mergeDancers(sourceDancerId, targetDancerId);
}
