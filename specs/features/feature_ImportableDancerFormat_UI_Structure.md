# Importable Dancer Format - UI Component Structure

## Overview
This document outlines the complete UI component hierarchy and structure for implementing the Importable Dancer Format feature. The design follows Material 3 principles and integrates seamlessly with the existing app architecture.

## 📋 Core UI Component Structure

### 1. Enhanced Dancers Screen
```
DancersScreen (existing - needs modification)
├── AppBar
│   ├── Title: "Dancers"
│   └── Actions: [Import Button] ← NEW
├── Search TextField (existing)
├── Dancers List (existing)
└── FloatingActionButton: Add Dancer (existing)
```

**Changes Required:**
- Add Import button to AppBar actions
- Icon: `Icons.file_upload` or `Icons.upload_file`
- Tooltip: "Import dancers from JSON file"
- Position: Before existing action buttons

### 2. Import Dancers Dialog (Main Component)
```
ImportDancersDialog (new - full-screen dialog)
├── AppBar
│   ├── Title: "Import Dancers"
│   ├── Close Button
│   └── Help Button (?)
├── Content: [Stepper Widget with 4 steps]
│   ├── Step 1: File Selection
│   ├── Step 2: Data Preview  
│   ├── Step 3: Import Options
│   └── Step 4: Results
└── Bottom Actions Bar
```

**Implementation Details:**
- Full-screen dialog using `showDialog` with custom route
- Material `Stepper` widget for guided flow
- Step validation before allowing progression
- Persistent bottom action bar with Next/Previous/Cancel buttons

## 📱 Step Components (Import Dialog Content)

### Step 1: File Selection Component
```
FileSelectionStep
├── DragDropZone
│   ├── Dotted border container
│   ├── Upload icon
│   ├── "Drop JSON file here" text
│   └── "or tap to browse" text
├── File Picker Button
├── Selected File Info Card (when file selected)
│   ├── File name
│   ├── File size
│   ├── Validation status icon
│   └── Clear selection button
└── Error Messages Container
```

**Features:**
- Drag and drop support for JSON files
- File type validation (JSON only)
- File size validation (max 1MB)
- Visual feedback for file selection states
- Clear error messaging for invalid files

### Step 2: Data Preview Component
```
DataPreviewStep
├── Import Statistics Card
│   ├── Total dancers count
│   ├── Valid dancers count
│   ├── Conflicts count
│   └── Warnings count
├── Preview Table
│   ├── Headers: [Name, Tags, Notes, Status]
│   ├── Data Rows
│   │   ├── Name column
│   │   ├── Tags chips
│   │   ├── Notes (truncated)
│   │   └── Status icon (✓ Valid, ⚠️ Conflict, ❌ Error)
│   └── Expandable rows for details
└── Conflict Resolution Hints
```

**Features:**
- Scrollable table with fixed headers
- Color-coded status indicators
- Expandable rows for detailed conflict information
- Search/filter functionality for large datasets
- Summary statistics at the top

### Step 3: Import Options Component
```
ImportOptionsStep
├── Conflict Resolution Section
│   ├── Radio buttons group
│   │   ├── Skip duplicates (default)
│   │   ├── Update existing dancers
│   │   └── Import with suffix
│   └── Preview of affected dancers
├── Tag Handling Section
│   ├── Checkbox: "Create missing tags automatically" (default: checked)
│   ├── New tags preview list
│   └── Existing tags list
└── Advanced Options (Expandable)
    ├── Validation strictness
    └── Batch size settings
```

**Features:**
- Clear default selections for common use cases
- Real-time preview of how options affect import
- Expandable advanced section for power users
- Help text explaining each option

### Step 4: Results Component
```
ResultsStep
├── Import Progress Bar (during import)
├── Results Summary Card
│   ├── Success count
│   ├── Skipped count
│   ├── Updated count
│   ├── Error count
│   └── Time taken
├── Detailed Results List
│   ├── Success items (expandable)
│   ├── Skipped items (expandable)
│   ├── Error items (expandable)
│   └── Action logs
└── Action Buttons
    ├── View Imported Dancers
    ├── Import Another File
    └── Close
```

**Features:**
- Real-time progress during import
- Comprehensive results summary
- Detailed logs for troubleshooting
- Quick actions for next steps

## 🧩 Supporting Components

### Import Statistics Widget
```
ImportStatsWidget
├── Card container
├── Grid of stat items
│   ├── Total count
│   ├── Valid count
│   ├── Conflicts count
│   └── Warnings count
└── Color-coded indicators
```

**Design:**
- 2x2 grid layout on mobile, 4x1 on tablet
- Color coding: Green (valid), Orange (warnings), Red (errors)
- Large numbers with descriptive labels

### Dancer Preview Card
```
DancerPreviewCard
├── Leading status icon
├── Name (primary text)
├── Tags chips row
├── Notes (subtitle, truncated)
├── Conflict indicators
└── Expandable details section
```

**Features:**
- Consistent with existing `DancerCardWithTags` design
- Status icons for quick visual scanning
- Truncated text with "show more" functionality
- Smooth expand/collapse animations

### Conflict Indicator Widget
```
ConflictIndicatorWidget
├── Warning icon
├── Conflict type text
├── Suggested resolution
└── Manual resolution options
```

**Types of Conflicts:**
- Duplicate names
- Invalid data formats
- Missing required fields
- Tag conflicts
- Database constraint violations

### Progress Tracker Widget
```
ProgressTrackerWidget
├── Overall progress bar
├── Current operation text
├── Items processed counter
└── Estimated time remaining
```

**Features:**
- Smooth progress animations
- Descriptive status text ("Processing dancer 15 of 100...")
- Time estimation based on processing speed
- Cancellation support

## 🎨 Design Specifications

### Color Scheme
Following existing `DanceThemeExtension`:
- **Success**: Green (`danceTheme.success`)
- **Warning**: Orange (`danceTheme.warning`) 
- **Error**: Red (`colorScheme.error`)
- **Primary**: Blue (`colorScheme.primary`)
- **Neutral**: Grey (`colorScheme.onSurfaceVariant`)

### Typography
- **Headers**: Material 3 `headlineSmall`
- **Body Text**: Material 3 `bodyMedium`
- **Labels**: Material 3 `labelMedium`
- **Captions**: Material 3 `bodySmall`

### Spacing
- **Section Spacing**: 24px
- **Item Spacing**: 16px
- **Compact Spacing**: 8px
- **Card Padding**: 16px

### Interactive Elements
- **Buttons**: Material 3 elevated/outlined buttons
- **Cards**: 12px border radius, 1px elevation
- **Chips**: Material 3 filter chips for tags
- **Progress**: Material 3 linear progress indicator

## 🔧 State Management Structure

### ImportState Class
```dart
class ImportState {
  // File selection
  File? selectedFile;
  
  // Parsing results
  ImportResult? parseResult;
  List<ImportableDancer> previewData;
  List<ImportConflict> conflicts;
  
  // User options
  ImportOptions options;
  
  // Import process
  bool isImporting;
  double importProgress;
  String currentOperation;
  
  // Results
  ImportSummary? results;
  
  // Navigation
  int currentStep;
  bool canProceed;
}
```

### Key Enums
```dart
enum ImportStep {
  fileSelection,
  dataPreview,
  importOptions,
  results
}

enum ConflictType {
  duplicateName,
  invalidData,
  missingField,
  tagConflict,
  constraintViolation
}

enum ImportStatus {
  pending,
  valid,
  warning,
  error
}
```

## 🔄 Integration Points

### Service Layer Integration
- **ImportService**: New service for import logic
- **DancerService**: Extended with bulk operations
- **TagService**: Extended with batch tag creation
- **Database**: Transaction support for atomic imports

### UI Integration
- **DancersScreen**: Import button in AppBar
- **Theme**: Use existing `DanceThemeExtension`
- **Navigation**: Modal dialog presentation
- **Feedback**: `ToastHelper` for notifications

### File System Integration
- **File Picker**: `file_picker` package for cross-platform support
- **Drag & Drop**: `desktop_drop` package for desktop support
- **Validation**: JSON schema validation
- **Error Handling**: Comprehensive error messaging

## 📝 Implementation Phases

### Phase 1: Core Components
1. Create `ImportDancersDialog` with stepper
2. Implement `FileSelectionStep` with basic file picker
3. Build `DataPreviewStep` with table display
4. Add import button to `DancersScreen`

### Phase 2: Advanced Features
1. Add drag & drop support
2. Implement conflict detection and resolution
3. Build `ImportOptionsStep` with configuration
4. Create progress tracking and results display

### Phase 3: Polish & Integration
1. Add comprehensive error handling
2. Implement accessibility features
3. Add help documentation and tooltips
4. Performance optimization for large files
5. Integration testing with existing flows

## 🎯 Success Criteria

### Functional Requirements
- ✅ Import valid JSON files successfully
- ✅ Display clear preview of import data
- ✅ Handle conflicts gracefully
- ✅ Provide progress feedback
- ✅ Show comprehensive results

### User Experience Requirements
- ✅ Intuitive step-by-step flow
- ✅ Clear error messages and guidance
- ✅ Responsive design for all screen sizes
- ✅ Consistent with app design language
- ✅ Accessible for screen readers

### Performance Requirements
- ✅ Handle files up to 1MB
- ✅ Process 1000+ dancers efficiently
- ✅ Responsive UI during import
- ✅ Minimal memory usage
- ✅ Fast validation and preview generation 