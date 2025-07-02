import '../../database/database.dart';

// Helper class for rank with usage statistics
class RankWithUsage {
  final Rank rank;
  final int usageCount;

  RankWithUsage({
    required this.rank,
    required this.usageCount,
  });
}

// Helper class for rankings with additional info
class RankingWithInfo {
  final int id;
  final int eventId;
  final int dancerId;
  final int rankId;
  final String? reason;
  final DateTime createdAt;
  final DateTime lastUpdated;
  final String dancerName;
  final String rankName;
  final int rankOrdinal;

  RankingWithInfo({
    required this.id,
    required this.eventId,
    required this.dancerId,
    required this.rankId,
    this.reason,
    required this.createdAt,
    required this.lastUpdated,
    required this.dancerName,
    required this.rankName,
    required this.rankOrdinal,
  });

  factory RankingWithInfo.fromRow(Map<String, dynamic> row) {
    return RankingWithInfo(
      id: row['id'] as int,
      eventId: row['event_id'] as int,
      dancerId: row['dancer_id'] as int,
      rankId: row['rank_id'] as int,
      reason: row['reason'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      lastUpdated: DateTime.parse(row['last_updated'] as String),
      dancerName: row['dancer_name'] as String,
      rankName: row['rank_name'] as String,
      rankOrdinal: row['rank_ordinal'] as int,
    );
  }
}

// Helper class for import rankings results
class ImportRankingsResult {
  final int imported;
  final int skipped;
  final int overwritten;
  final int sourceRankingsCount;

  ImportRankingsResult({
    required this.imported,
    required this.skipped,
    required this.overwritten,
    required this.sourceRankingsCount,
  });

  int get totalProcessed => imported + skipped + overwritten;
  bool get hasAnyChanges => imported > 0 || overwritten > 0;

  String get summaryMessage {
    if (sourceRankingsCount == 0) {
      return 'No rankings found in source event';
    }

    final parts = <String>[];
    if (imported > 0) parts.add('$imported imported');
    if (overwritten > 0) parts.add('$overwritten overwritten');
    if (skipped > 0) parts.add('$skipped skipped');

    return parts.isEmpty ? 'No changes made' : parts.join(', ');
  }
}
