// Helper class for attendance with dancer info
class AttendanceWithDancerInfo {
  final int id;
  final int eventId;
  final int dancerId;
  final DateTime markedAt;
  final String status;
  final DateTime? dancedAt;
  final String? impression;
  final int? scoreId;
  final String dancerName;
  final String? dancerNotes;

  AttendanceWithDancerInfo({
    required this.id,
    required this.eventId,
    required this.dancerId,
    required this.markedAt,
    required this.status,
    this.dancedAt,
    this.impression,
    this.scoreId,
    required this.dancerName,
    this.dancerNotes,
  });

  // Backward compatibility getter
  bool get hasDanced => status == 'served';

  factory AttendanceWithDancerInfo.fromRow(Map<String, dynamic> row) {
    return AttendanceWithDancerInfo(
      id: row['id'] as int,
      eventId: row['event_id'] as int,
      dancerId: row['dancer_id'] as int,
      markedAt: DateTime.parse(row['marked_at'] as String),
      status: row['status'] as String,
      dancedAt: row['danced_at'] != null
          ? DateTime.parse(row['danced_at'] as String)
          : null,
      impression: row['impression'] as String?,
      scoreId: row['score_id'] as int?,
      dancerName: row['dancer_name'] as String,
      dancerNotes: row['dancer_notes'] as String?,
    );
  }
}

// Attendance statistics
class AttendanceStats {
  final int presentCount;
  final int dancedCount;
  final int notDancedCount;

  AttendanceStats({
    required this.presentCount,
    required this.dancedCount,
    required this.notDancedCount,
  });

  double get dancedPercentage =>
      presentCount > 0 ? (dancedCount / presentCount) * 100 : 0;
}
