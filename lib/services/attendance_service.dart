import '../database/database.dart';
import 'attendance/attendance_crud_service.dart';
import 'attendance/attendance_dance_service.dart';
import 'attendance/attendance_models.dart';
import 'attendance/attendance_query_service.dart';
import 'attendance/attendance_score_service.dart';
import 'attendance/attendance_stats_service.dart';

// Re-export models for backward compatibility
export 'attendance/attendance_models.dart';

class AttendanceService {
  final AppDatabase _database;

  // Specialized services
  late final AttendanceCrudService _crudService;
  late final AttendanceDanceService _danceService;
  late final AttendanceScoreService _scoreService;
  late final AttendanceQueryService _queryService;
  late final AttendanceStatsService _statsService;

  AttendanceService(this._database) {
    // Initialize specialized services with dependency injection
    _crudService = AttendanceCrudService(_database);
    _danceService = AttendanceDanceService(_database, _crudService);
    _scoreService = AttendanceScoreService(_database, _crudService);
    _queryService = AttendanceQueryService(_database);
    _statsService = AttendanceStatsService(_database);
  }

  // CRUD Operations - delegated to AttendanceCrudService
  Future<int> markPresent(int eventId, int dancerId) =>
      _crudService.markPresent(eventId, dancerId);

  Future<int> removeFromPresent(int eventId, int dancerId) =>
      _crudService.removeFromPresent(eventId, dancerId);

  Future<bool> markAsLeft(int eventId, int dancerId) =>
      _crudService.markAsLeft(eventId, dancerId);

  Future<Attendance?> getAttendance(int eventId, int dancerId) =>
      _crudService.getAttendance(eventId, dancerId);

  Future<bool> isPresent(int eventId, int dancerId) =>
      _crudService.isPresent(eventId, dancerId);

  Future<bool> hasDanced(int eventId, int dancerId) =>
      _crudService.hasDanced(eventId, dancerId);

  Stream<List<Attendance>> watchPresentDancers(int eventId) =>
      _crudService.watchPresentDancers(eventId);

  // Dance Operations - delegated to AttendanceDanceService
  Future<bool> recordDance({
    required int eventId,
    required int dancerId,
    String? impression,
  }) =>
      _danceService.recordDance(
        eventId: eventId,
        dancerId: dancerId,
        impression: impression,
      );

  Future<int> createAttendanceWithDance({
    required int eventId,
    required int dancerId,
    String? impression,
  }) =>
      _danceService.createAttendanceWithDance(
        eventId: eventId,
        dancerId: dancerId,
        impression: impression,
      );

  Future<bool> updateDanceImpression({
    required int eventId,
    required int dancerId,
    String? impression,
  }) =>
      _danceService.updateDanceImpression(
        eventId: eventId,
        dancerId: dancerId,
        impression: impression,
      );

  // Score Operations - delegated to AttendanceScoreService
  Future<bool> assignScore(int eventId, int dancerId, int scoreId) =>
      _scoreService.assignScore(eventId, dancerId, scoreId);

  Future<bool> removeScore(int eventId, int dancerId) =>
      _scoreService.removeScore(eventId, dancerId);

  Future<int?> getAttendanceScore(int eventId, int dancerId) =>
      _scoreService.getAttendanceScore(eventId, dancerId);

  // Query Operations - delegated to AttendanceQueryService
  Future<List<AttendanceWithDancerInfo>> getPresentDancersWithInfo(
          int eventId) =>
      _queryService.getPresentDancersWithInfo(eventId);

  Future<List<AttendanceWithDancerInfo>> getDancedDancers(int eventId) =>
      _queryService.getDancedDancers(eventId);

  // Statistics Operations - delegated to AttendanceStatsService
  Future<int> getPresentCount(int eventId) =>
      _statsService.getPresentCount(eventId);

  Future<int> getDancedCount(int eventId) =>
      _statsService.getDancedCount(eventId);

  Future<AttendanceStats> getAttendanceStats(int eventId) =>
      _statsService.getAttendanceStats(eventId);
}
