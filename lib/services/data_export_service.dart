import 'dart:convert';

import '../database/database.dart';
import '../utils/action_logger.dart';

class DataExportService {
  final AppDatabase _database;

  DataExportService(this._database);

  Future<String> exportDataAsJson() async {
    ActionLogger.logServiceCall('DataExportService', 'exportDataAsJson');
    try {
      final allData = await _fetchAllData();
      final jsonData = {
        'version': '1.0.0',
        'exportDate': DateTime.now().toIso8601String(),
        'data': allData,
      };
      return jsonEncode(jsonData);
    } catch (e, s) {
      ActionLogger.logError(
          'DataExportService.exportDataAsJson', 'Error: $e\nStackTrace: $s');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _fetchAllData() async {
    final ranks = await (_database.select(_database.ranks)).get();
    final tags = await (_database.select(_database.tags)).get();
    final dancers = await (_database.select(_database.dancers)).get();
    final dancerTags = await (_database.select(_database.dancerTags)).get();
    final events = await (_database.select(_database.events)).get();
    final rankings = await (_database.select(_database.rankings)).get();
    final attendances = await (_database.select(_database.attendances)).get();

    return {
      'ranks': ranks.map((r) => r.toJson()).toList(),
      'tags': tags.map((t) => t.toJson()).toList(),
      'dancers': dancers.map((d) => d.toJson()).toList(),
      'dancerTags': dancerTags.map((dt) => dt.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
      'rankings': rankings.map((r) => r.toJson()).toList(),
      'attendances': attendances.map((a) => a.toJson()).toList(),
    };
  }
}
