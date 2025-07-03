import '../database/database.dart';
import 'ranking/rank_management_service.dart';
import 'ranking/ranking_import_service.dart';
import 'ranking/ranking_models.dart';
import 'ranking/ranking_operations_service.dart';
import 'ranking/ranking_usage_service.dart';

// Re-export models for backward compatibility
export 'ranking/ranking_models.dart';

class RankingService {
  final AppDatabase _database;
  late final RankManagementService _rankManagementService;
  late final RankingOperationsService _operationsService;
  late final RankingImportService _importService;
  late final RankingUsageService _usageService;

  RankingService(this._database) {
    _rankManagementService = RankManagementService(_database);
    _operationsService = RankingOperationsService(_database);
    _importService = RankingImportService(_database, _operationsService);
    _usageService = RankingUsageService(_database);
  }

  // Rank Management Methods
  Future<List<Rank>> getAllRanks() => _rankManagementService.getAllRanks();

  Future<Rank?> getRank(int id) => _rankManagementService.getRank(id);

  Future<List<Rank>> getActiveRanks() => _rankManagementService.getActiveRanks();

  Future<int> createRank({
    required String name,
    required int ordinal,
  }) =>
      _rankManagementService.createRank(name: name, ordinal: ordinal);

  Future<bool> updateRank({
    required int id,
    String? name,
    int? ordinal,
    bool? isArchived,
  }) =>
      _rankManagementService.updateRank(
        id: id,
        name: name,
        ordinal: ordinal,
        isArchived: isArchived,
      );

  Future<bool> archiveRank(int id) => _rankManagementService.archiveRank(id);

  Future<bool> unarchiveRank(int id) => _rankManagementService.unarchiveRank(id);

  Future<bool> deleteRank({
    required int id,
    required int replacementRankId,
  }) =>
      _rankManagementService.deleteRank(
        id: id,
        replacementRankId: replacementRankId,
      );

  Future<bool> updateRankOrdinals(List<Rank> ranks) => _rankManagementService.updateRankOrdinals(ranks);

  // Ranking Operations Methods
  Future<int> setRanking({
    required int eventId,
    required int dancerId,
    required int rankId,
    String? reason,
  }) =>
      _operationsService.setRanking(
        eventId: eventId,
        dancerId: dancerId,
        rankId: rankId,
        reason: reason,
      );

  Future<Ranking?> getRanking(int eventId, int dancerId) => _operationsService.getRanking(eventId, dancerId);

  Future<List<RankingWithInfo>> getRankingsForEvent(int eventId) => _operationsService.getRankingsForEvent(eventId);

  Future<Map<String, List<RankingWithInfo>>> getRankingsGroupedByRank(int eventId) =>
      _operationsService.getRankingsGroupedByRank(eventId);

  Future<int> deleteRanking(int eventId, int dancerId) => _operationsService.deleteRanking(eventId, dancerId);

  // Quick rank assignment methods
  Future<int> setRankReallyWantToDance(int eventId, int dancerId, {String? reason}) =>
      _operationsService.setRankReallyWantToDance(eventId, dancerId, reason: reason);

  Future<int> setRankWouldLikeToDance(int eventId, int dancerId, {String? reason}) =>
      _operationsService.setRankWouldLikeToDance(eventId, dancerId, reason: reason);

  Future<int> setRankNeutral(int eventId, int dancerId, {String? reason}) =>
      _operationsService.setRankNeutral(eventId, dancerId, reason: reason);

  Future<int> setRankMaybeLater(int eventId, int dancerId, {String? reason}) =>
      _operationsService.setRankMaybeLater(eventId, dancerId, reason: reason);

  Future<int> setRankNotInterested(int eventId, int dancerId, {String? reason}) =>
      _operationsService.setRankNotInterested(eventId, dancerId, reason: reason);

  // Import/Export Methods
  Future<ImportRankingsResult> importRankingsFromEvent({
    required int sourceEventId,
    required int targetEventId,
    bool overwriteExisting = false,
  }) =>
      _importService.importRankingsFromEvent(
        sourceEventId: sourceEventId,
        targetEventId: targetEventId,
        overwriteExisting: overwriteExisting,
      );

  // Usage Statistics Methods
  Future<int> getRankUsageCount(int rankId) => _usageService.getRankUsageCount(rankId);

  Future<List<RankWithUsage>> getAllRanksWithUsage() => _usageService.getAllRanksWithUsage();

  Future<int> getRankingsCountForEvent(int eventId) => _usageService.getRankingsCountForEvent(eventId);
}
