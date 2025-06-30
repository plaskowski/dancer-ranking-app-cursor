# Feature: Tags on Persons

## Overview
Add simple tagging system to dancers to categorize them with visual pill-based selection and display.

## User Stories
- As a user, I want to tag dancers with categories like "regular", "dance-class", "rare" so I can organize them
- As a user, I want to see tags displayed on dancer cards so I know the context of each person

### Future User Stories
- As a user, I want to search by tags so I can quickly find dancers from specific contexts
- As a user, I want to filter dancers by tags when selecting for events

## Database Schema

### New Tables
```sql
-- Tags table
CREATE TABLE tags (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Dancer-Tag relationships (many-to-many)
CREATE TABLE dancer_tags (
  dancer_id INTEGER NOT NULL REFERENCES dancers(id) ON DELETE CASCADE,
  tag_id INTEGER NOT NULL REFERENCES tags(id) ON DELETE CASCADE,
  PRIMARY KEY (dancer_id, tag_id)
);
```

### Predefined Tags
Initial set of common tags to be created:
- `regular` - comes often
- `occasional` - comes sometimes  
- `rare` - comes rarely
- `new` - new person
- `dance-class` - from dance class
- `dance-school` - from dance school
- `workshop` - met at workshop
- `social` - from social events

## UI Changes

### Edit Dancer Dialog
Add a new section with **Tag Selection Pills**:
- Section header: "Tags"
- paragraph with toggleable pill buttons
- Active tags are highlighted/selected
- Inactive tags are dim/unselected
- Visual example:
  ```
  Tags:
  [●regular] [○occasional] [○rare] [●new]
  [●dance-class] [○dance-school] [○workshop] [○social]
  ```

### Dancers List Display
- Show active tags as small chips/badges under dancer name
- Keep visual design simple (no colors initially)
- Format: Small text badges below name

## Implementation Steps

### Phase 1: Database Foundation
1. Create database migration for tags and dancer_tags tables
2. Insert predefined tags into tags table
3. Create Tag and DancerTag models in Drift

### Phase 2: Basic Tag Management
1. Create TagService for tag operations
2. Update DancerService to handle tag relationships
3. Modify Add/Edit Dancer dialog with pill selection UI

### Phase 3: Display
1. Update dancer list to show tags
2. Test tag assignment and display

## Future Enhancements (Later Implementation)

### Enhanced Search & Filtering
Extend existing `searchDancers()` method:
- Current: searches dancer names only
- Enhanced: also searches in tag names
- Example: typing "dance-class" shows all dancers with that tag
- Combined search: "john dance-class" finds Johns from dance class

### Event Integration
1. Add tag filtering to Select Dancers screen
2. Use tags for "dancers pool category" functionality
3. Advanced filtering options (multiple tags, exclude tags)

## Technical Notes
- Tags are case-insensitive (stored lowercase)
- Many-to-many relationship allows multiple tags per dancer
- Cascade delete ensures cleanup when dancers are removed

### Future Technical Notes
- Search should be efficient with proper indexing
- Tag filtering queries will need optimization for large datasets

## Success Criteria
- [ ] Can assign multiple tags to any dancer
- [ ] Tags display clearly in dancers list
- [ ] Tag selection is intuitive with pill interface
- [ ] Tag data persists correctly in database

### Future Success Criteria
- [ ] Search finds dancers by tag names
- [ ] Can filter dancers by tags in event selection
- [ ] Advanced filtering works with multiple tags 