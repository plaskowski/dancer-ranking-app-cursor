# Feature: Tags on Persons

## Overview
Add simple tagging system to dancers to categorize them and enable tag-based search and filtering.

## User Stories
- As a user, I want to tag dancers with categories like "regular", "dance-class", "rare" so I can organize them
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

### Enhanced Search
Extend existing `searchDancers()` method:
- Current: searches dancer names only
- Enhanced: also searches in tag names
- Example: typing "dance-class" shows all dancers with that tag
- Combined search: "john dance-class" finds Johns from dance class

## Implementation Steps

### Phase 1: Database Foundation
1. Create database migration for tags and dancer_tags tables
2. Insert predefined tags into tags table
3. Create Tag and DancerTag models in Drift

### Phase 2: Basic Tag Management
1. Create TagService for tag operations
2. Update DancerService to handle tag relationships
3. Modify Add/Edit Dancer dialog with pill selection UI

### Phase 3: Display & Search
1. Update dancer list to show tags
2. Enhance search functionality to include tags
3. Test tag-based filtering

### Phase 4: Integration
1. Add tag filtering to Select Dancers screen
2. Use tags for "dancers pool category" functionality
3. Test complete workflow

## Technical Notes
- Tags are case-insensitive (stored lowercase)
- Many-to-many relationship allows multiple tags per dancer
- Cascade delete ensures cleanup when dancers are removed
- Search should be efficient with proper indexing

## Success Criteria
- [ ] Can assign multiple tags to any dancer
- [ ] Tags display clearly in dancers list
- [ ] Search finds dancers by tag names
- [ ] Tag selection is intuitive with pill interface
- [ ] Tag data persists correctly in database 