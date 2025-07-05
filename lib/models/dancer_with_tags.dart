import '../database/database.dart';

class DancerWithTags {
  final Dancer dancer;
  final List<Tag> tags;
  final String? lastMetEventName;
  final DateTime? lastMetEventDate;

  DancerWithTags({
    required this.dancer,
    required this.tags,
    this.lastMetEventName,
    this.lastMetEventDate,
  });

  // Convenience getters
  int get id => dancer.id;
  String get name => dancer.name;
  String? get notes => dancer.notes;
  DateTime get createdAt => dancer.createdAt;

  // Check if dancer has a specific tag
  bool hasTag(String tagName) {
    return tags.any((tag) => tag.name == tagName);
  }

  // Get tag names as a list
  List<String> get tagNames => tags.map((tag) => tag.name).toList();

  // Get formatted tag names for display
  String get formattedTags => tagNames.join(', ');

  @override
  String toString() {
    return 'DancerWithTags(dancer: ${dancer.name}, tags: ${tagNames.join(', ')}, lastMetEvent: '
        '${lastMetEventName ?? '-'} on ${lastMetEventDate?.toIso8601String() ?? '-'}])';
  }
}
