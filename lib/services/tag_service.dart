import 'package:drift/drift.dart';

import '../database/database.dart';
import '../utils/action_logger.dart';

class TagService {
  final AppDatabase _database;

  TagService(this._database);

  // Get all tags ordered by name
  Stream<List<Tag>> watchAllTags() {
    ActionLogger.logServiceCall('TagService', 'watchAllTags');

    return (_database.select(_database.tags)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  // Get a specific tag by ID
  Future<Tag?> getTag(int id) {
    ActionLogger.logServiceCall('TagService', 'getTag', {'tagId': id});

    return (_database.select(_database.tags)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  // Get tag by name
  Future<Tag?> getTagByName(String name) {
    ActionLogger.logServiceCall('TagService', 'getTagByName', {'name': name});

    return (_database.select(_database.tags)
          ..where((t) => t.name.equals(name.toLowerCase())))
        .getSingleOrNull();
  }

  // Create a new tag
  Future<int> createTag(String name) async {
    ActionLogger.logServiceCall('TagService', 'createTag', {'name': name});

    try {
      final normalizedName = name.toLowerCase().trim();

      // Check if tag already exists
      final existingTag = await getTagByName(normalizedName);
      if (existingTag != null) {
        ActionLogger.logAction('TagService.createTag', 'tag_already_exists', {
          'name': normalizedName,
          'existingId': existingTag.id,
        });
        return existingTag.id;
      }

      final id = await _database.into(_database.tags).insert(
            TagsCompanion.insert(
              name: normalizedName,
            ),
          );

      ActionLogger.logDbOperation('INSERT', 'tags', {
        'id': id,
        'name': normalizedName,
      });

      return id;
    } catch (e) {
      ActionLogger.logError('TagService.createTag', e.toString(), {
        'name': name,
      });
      rethrow;
    }
  }

  // Update an existing tag
  Future<bool> updateTag({
    required int id,
    required String name,
  }) async {
    ActionLogger.logServiceCall('TagService', 'updateTag', {
      'id': id,
      'name': name,
    });

    try {
      final normalizedName = name.toLowerCase().trim();

      // Check if another tag already exists with this name
      final existingTag = await getTagByName(normalizedName);
      if (existingTag != null && existingTag.id != id) {
        ActionLogger.logError(
            'TagService.updateTag', 'tag_name_already_exists', {
          'id': id,
          'name': normalizedName,
          'existingId': existingTag.id,
        });
        throw Exception('Tag with name "$normalizedName" already exists');
      }

      final existing = await getTag(id);
      if (existing == null) {
        ActionLogger.logError('TagService.updateTag', 'tag_not_found', {
          'id': id,
        });
        return false;
      }

      final result = await _database.update(_database.tags).replace(
            existing.copyWith(
              name: normalizedName,
            ),
          );

      ActionLogger.logDbOperation('UPDATE', 'tags', {
        'id': id,
        'name': normalizedName,
        'success': result,
      });

      return result;
    } catch (e) {
      ActionLogger.logError('TagService.updateTag', e.toString(), {
        'id': id,
        'name': name,
      });
      rethrow;
    }
  }

  // Delete a tag (with automatic cleanup of dancer-tag relationships)
  Future<bool> deleteTag(int id) async {
    ActionLogger.logServiceCall('TagService', 'deleteTag', {
      'id': id,
    });

    try {
      final existing = await getTag(id);
      if (existing == null) {
        ActionLogger.logError('TagService.deleteTag', 'tag_not_found', {
          'id': id,
        });
        return false;
      }

      // Get usage count before deletion for logging
      final usageCount =
          await getDancersByTag(id).then((dancers) => dancers.length);

      final result = await (_database.delete(_database.tags)
            ..where((t) => t.id.equals(id)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'tags', {
        'id': id,
        'name': existing.name,
        'usageCount': usageCount,
        'success': result > 0,
        'affected_rows': result,
      });

      return result > 0;
    } catch (e) {
      ActionLogger.logError('TagService.deleteTag', e.toString(), {
        'id': id,
      });
      rethrow;
    }
  }

  // Get tags for a specific dancer
  Future<List<Tag>> getDancerTags(int dancerId) async {
    ActionLogger.logServiceCall('TagService', 'getDancerTags', {
      'dancerId': dancerId,
    });

    try {
      final query = _database.select(_database.tags).join([
        innerJoin(
          _database.dancerTags,
          _database.tags.id.equalsExp(_database.dancerTags.tagId),
        ),
      ])
        ..where(_database.dancerTags.dancerId.equals(dancerId))
        ..orderBy([OrderingTerm.asc(_database.tags.name)]);

      final results = await query.get();
      return results.map((row) => row.readTable(_database.tags)).toList();
    } catch (e) {
      ActionLogger.logError('TagService.getDancerTags', e.toString(), {
        'dancerId': dancerId,
      });
      rethrow;
    }
  }

  // Add a tag to a dancer
  Future<void> addTagToDancer(int dancerId, int tagId) async {
    ActionLogger.logServiceCall('TagService', 'addTagToDancer', {
      'dancerId': dancerId,
      'tagId': tagId,
    });

    try {
      await _database.into(_database.dancerTags).insert(
            DancerTagsCompanion.insert(
              dancerId: dancerId,
              tagId: tagId,
            ),
            mode: InsertMode.insertOrIgnore, // Avoid duplicates
          );

      ActionLogger.logDbOperation('INSERT', 'dancer_tags', {
        'dancerId': dancerId,
        'tagId': tagId,
      });
    } catch (e) {
      ActionLogger.logError('TagService.addTagToDancer', e.toString(), {
        'dancerId': dancerId,
        'tagId': tagId,
      });
      rethrow;
    }
  }

  // Remove a tag from a dancer
  Future<void> removeTagFromDancer(int dancerId, int tagId) async {
    ActionLogger.logServiceCall('TagService', 'removeTagFromDancer', {
      'dancerId': dancerId,
      'tagId': tagId,
    });

    try {
      final result = await (_database.delete(_database.dancerTags)
            ..where(
                (dt) => dt.dancerId.equals(dancerId) & dt.tagId.equals(tagId)))
          .go();

      ActionLogger.logDbOperation('DELETE', 'dancer_tags', {
        'dancerId': dancerId,
        'tagId': tagId,
        'affected_rows': result,
      });
    } catch (e) {
      ActionLogger.logError('TagService.removeTagFromDancer', e.toString(), {
        'dancerId': dancerId,
        'tagId': tagId,
      });
      rethrow;
    }
  }

  // Set all tags for a dancer (replaces existing tags)
  Future<void> setDancerTags(int dancerId, List<int> tagIds) async {
    ActionLogger.logServiceCall('TagService', 'setDancerTags', {
      'dancerId': dancerId,
      'tagCount': tagIds.length,
    });

    try {
      await _database.transaction(() async {
        // Remove all existing tags for this dancer
        await (_database.delete(_database.dancerTags)
              ..where((dt) => dt.dancerId.equals(dancerId)))
            .go();

        // Add the new tags
        if (tagIds.isNotEmpty) {
          await _database.batch((batch) {
            for (final tagId in tagIds) {
              batch.insert(
                _database.dancerTags,
                DancerTagsCompanion.insert(
                  dancerId: dancerId,
                  tagId: tagId,
                ),
              );
            }
          });
        }
      });

      ActionLogger.logDbOperation('REPLACE', 'dancer_tags', {
        'dancerId': dancerId,
        'newTagIds': tagIds,
        'tagCount': tagIds.length,
      });
    } catch (e) {
      ActionLogger.logError('TagService.setDancerTags', e.toString(), {
        'dancerId': dancerId,
        'tagIds': tagIds,
      });
      rethrow;
    }
  }

  // Get dancers by tag
  Future<List<Dancer>> getDancersByTag(int tagId) async {
    ActionLogger.logServiceCall('TagService', 'getDancersByTag', {
      'tagId': tagId,
    });

    try {
      final query = _database.select(_database.dancers).join([
        innerJoin(
          _database.dancerTags,
          _database.dancers.id.equalsExp(_database.dancerTags.dancerId),
        ),
      ])
        ..where(_database.dancerTags.tagId.equals(tagId))
        ..orderBy([OrderingTerm.asc(_database.dancers.name)]);

      final results = await query.get();
      return results.map((row) => row.readTable(_database.dancers)).toList();
    } catch (e) {
      ActionLogger.logError('TagService.getDancersByTag', e.toString(), {
        'tagId': tagId,
      });
      rethrow;
    }
  }

  // Get all tags with usage count
  Future<List<TagWithUsageCount>> getAllTagsWithUsageCount() async {
    ActionLogger.logServiceCall('TagService', 'getAllTagsWithUsageCount');

    try {
      const query = '''
        SELECT t.id, t.name, t.created_at, COUNT(dt.dancer_id) as usage_count
        FROM tags t
        LEFT JOIN dancer_tags dt ON t.id = dt.tag_id
        GROUP BY t.id, t.name, t.created_at
        ORDER BY t.name
      ''';

      final results = await _database.customSelect(query).get();

      return results.map((row) {
        return TagWithUsageCount(
          tag: Tag(
            id: row.read<int>('id'),
            name: row.read<String>('name'),
            createdAt: row.read<DateTime>('created_at'),
          ),
          usageCount: row.read<int>('usage_count'),
        );
      }).toList();
    } catch (e) {
      ActionLogger.logError(
          'TagService.getAllTagsWithUsageCount', e.toString());
      rethrow;
    }
  }
}

// Helper class for tag with usage count
class TagWithUsageCount {
  final Tag tag;
  final int usageCount;

  TagWithUsageCount({
    required this.tag,
    required this.usageCount,
  });
}
