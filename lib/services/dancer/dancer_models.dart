// Helper class to combine dancer info with event-specific data
class DancerWithEventInfo {
  final int id;
  final String name;
  final String? notes;
  final DateTime createdAt;
  final DateTime? firstMetDate;
  final String? rankName;
  final int? rankOrdinal;
  final String? rankingReason;
  final DateTime? rankingUpdated;
  final DateTime? attendanceMarkedAt;
  final String status; // present, served, left, absent
  final DateTime? dancedAt;
  final String? impression;
  final String? scoreName;
  final int? scoreOrdinal;
  final int? scoreId;
  final bool isFirstMetHere;

  DancerWithEventInfo({
    required this.id,
    required this.name,
    this.notes,
    required this.createdAt,
    this.firstMetDate,
    this.rankName,
    this.rankOrdinal,
    this.rankingReason,
    this.rankingUpdated,
    this.attendanceMarkedAt,
    required this.status,
    this.dancedAt,
    this.impression,
    this.scoreName,
    this.scoreOrdinal,
    this.scoreId,
    required this.isFirstMetHere,
  });

  // Helper getters
  bool get isPresent => attendanceMarkedAt != null;
  bool get hasRanking => rankName != null;
  bool get isRanked => hasRanking;
  bool get hasScore => scoreName != null;

  // Status-based convenience getters for backward compatibility
  bool get hasDanced => status == 'served';
  bool get hasLeft => status == 'left';
  bool get isAbsent => status == 'absent';
}

class DancerRecentHistory {
  final String eventName;
  final DateTime eventDate;
  final String status; // 'present', 'served', 'left'
  final String? impression;
  final String? scoreName;

  DancerRecentHistory({
    required this.eventName,
    required this.eventDate,
    required this.status,
    this.impression,
    this.scoreName,
  });

  // Simple computed properties
  bool get danced => status == 'served';
  // Note: For UI, we only care if they danced or not
}
