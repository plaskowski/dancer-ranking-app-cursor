# File Size Distribution Analysis

## Overview
Analysis of the Dancer Ranking App Dart codebase to identify large files that may benefit from refactoring into smaller, more manageable components.

**Analysis Date**: December 2024  
**Total Files Analyzed**: 54 Dart files  
**Total Lines of Code**: 21,257 lines

## File Size Distribution Summary

### Overall Statistics
- **Total lines of code**: 21,257 lines across 54 Dart files
- **Average file size**: ~394 lines per file
- **Largest manually written file**: `settings_screen.dart` (1,147 lines)
- **Generated file**: `database.g.dart` (5,239 lines) - excluded from refactoring recommendations

### Size Distribution by Category

| Size Category | File Count | Percentage | Lines Range | Action Required |
|---------------|------------|------------|-------------|-----------------|
| Very Large    | 6          | 11.1%      | 500+ lines  | High Priority   |
| Large         | 8          | 14.8%      | 300-499     | Medium Priority |
| Medium        | 12         | 22.2%      | 200-299     | Monitor         |
| Small         | 28         | 51.9%      | <200        | Good Size       |

## Detailed File Analysis

### 🔴 Very Large Files (>500 lines) - REFACTORING NEEDED

#### 1. `lib/screens/settings/settings_screen.dart` - **1,147 lines** ⚠️ **CRITICAL**
**Issues**:
- Contains 3 major tab widgets in one file
- Multiple responsibilities mixed together
- Hard to maintain and test

**Current structure**:
- `_GeneralSettingsTab`
- `_RanksManagementTab` 
- `_ScoresManagementTab`
- `_InfoRow` widget
- `_RankCard` widget

**Recommended refactoring**:
```
lib/screens/settings/
├── settings_screen.dart (main coordinator ~150 lines)
├── tabs/
│   ├── general_settings_tab.dart (~200 lines)
│   ├── ranks_management_tab.dart (~400 lines)
│   └── scores_management_tab.dart (~300 lines)
└── widgets/
    ├── info_row.dart (~50 lines)
    └── rank_card.dart (~100 lines)
```

#### 2. `lib/services/ranking_service.dart` - **673 lines** ⚠️ **HIGH PRIORITY**
**Issues**:
- Large service class with many responsibilities
- Mix of CRUD operations and complex business logic

**Recommended refactoring**:
- Split into `RankingService` (core CRUD operations)
- Extract `RankingManagementService` (bulk operations, reordering)

#### 3. `lib/services/dancer_service.dart` - **567 lines** ⚠️ **HIGH PRIORITY**
**Issues**:
- Large service with mixed responsibilities
- Search functionality could be extracted

**Recommended refactoring**:
- Keep core CRUD operations in `DancerService`
- Extract search functionality into `DancerSearchService`

#### 4. `lib/screens/home/home_screen.dart` - **557 lines** ⚠️ **HIGH PRIORITY**
**Issues**:
- Large screen component with embedded widgets
- Import functionality mixed with display logic

**Recommended refactoring**:
- Extract `_EventCard` widget to separate file
- Extract import event functionality to separate widget/service

#### 5. `lib/services/attendance_service.dart` - **536 lines** ⚠️ **MEDIUM PRIORITY**
**Issues**:
- Large service class

**Recommended action**:
- Review for potential split based on functionality groups

#### 6. `lib/services/event_import_service.dart` - **527 lines** ⚠️ **MEDIUM PRIORITY**
**Issues**:
- Complex import logic in single file

**Recommended action**:
- Consider extracting validation and parsing logic

### 🟡 Large Files (300-499 lines) - MONITOR

1. `lib/models/import_models.dart` (484 lines)
2. `lib/screens/settings/tabs/tags_screen.dart` (442 lines)
3. `lib/widgets/import/import_dancers_dialog.dart` (418 lines)
4. `lib/services/dancer_import_service.dart` (398 lines)
5. `lib/widgets/add_dancer_dialog.dart` (396 lines)
6. `lib/screens/event/tabs/summary_tab.dart` (392 lines)
7. `lib/widgets/import_events_dialog.dart` (371 lines)
8. `lib/services/event_import_validator.dart` (364 lines)

These files are approaching the threshold for refactoring consideration but are not immediately critical.

### 🟢 Medium Files (200-299 lines) - ACCEPTABLE SIZE

12 files in this range - generally well-sized and manageable.

### ⚪ Small Files (<200 lines) - OPTIMAL SIZE

28 files in this range - good size for maintainability.

## Priority Action Plan

### IMMEDIATE (This Week)
**Target**: `settings_screen.dart` (1,147 lines → ~150 lines main + 4-5 smaller files)

1. Extract `_GeneralSettingsTab` to `lib/screens/settings/tabs/general_settings_tab.dart`
2. Extract `_RanksManagementTab` to `lib/screens/settings/tabs/ranks_management_tab.dart`
3. Extract `_ScoresManagementTab` to `lib/screens/settings/tabs/scores_management_tab.dart`
4. Extract `_InfoRow` to `lib/screens/settings/widgets/info_row.dart`
5. Extract `_RankCard` to `lib/screens/settings/widgets/rank_card.dart`
6. Keep main `SettingsScreen` as coordinator with tab controller

### HIGH PRIORITY (Next 2 weeks)
1. **Refactor `ranking_service.dart`** (673 lines)
   - Split core CRUD operations vs. management operations
   
2. **Refactor `dancer_service.dart`** (567 lines)
   - Extract search functionality
   
3. **Refactor `home_screen.dart`** (557 lines)
   - Extract event card widget
   - Extract import functionality

### MEDIUM PRIORITY (Next month)
1. Review and potentially split attendance and import services
2. Extract common patterns from import dialogs
3. Consider splitting large model files if they contain unrelated entities

## Refactoring Benefits

### Maintainability
- **Easier navigation**: Developers can quickly find relevant code
- **Focused changes**: Modifications affect smaller, more targeted files
- **Reduced cognitive load**: Smaller files are easier to understand

### Testing
- **Unit testing**: Smaller classes are easier to test in isolation
- **Test organization**: Tests can be organized by smaller functional units
- **Faster test feedback**: Smaller components compile and test faster

### Team Collaboration
- **Reduced merge conflicts**: Smaller files mean less chance of conflicting changes
- **Parallel development**: Different team members can work on different components
- **Code review**: Smaller files are easier to review thoroughly

### Performance
- **Compilation time**: Flutter/Dart compiles changed files faster when they're smaller
- **IDE performance**: Better syntax highlighting and analysis on smaller files
- **Hot reload**: Faster hot reload times with smaller widget files

## Implementation Guidelines

### File Size Targets
- **Widgets**: 100-300 lines ideal, 400 lines maximum
- **Services**: 200-400 lines ideal, 500 lines maximum  
- **Screens**: 150-350 lines ideal, 400 lines maximum
- **Models**: 50-200 lines ideal, 300 lines maximum

### Refactoring Best Practices
1. **Single Responsibility**: Each file should have one clear purpose
2. **Logical Grouping**: Related functionality should stay together
3. **Import Management**: Minimize cross-dependencies
4. **Testing**: Ensure refactored components remain fully tested
5. **Documentation**: Update documentation after refactoring

## Monitoring Strategy

### Regular Reviews
- **Monthly**: Review files approaching 400+ lines
- **Quarterly**: Analyze overall codebase health
- **Per Feature**: Check file sizes when adding new features

### Automated Checks
Consider adding linter rules or CI checks to flag files exceeding size thresholds.

---

*This analysis was generated on December 2024 and should be updated periodically as the codebase evolves.* 