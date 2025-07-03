# Event Import Scripts

## validate_imports.sh

This script validates all JSON files in a directory to ensure they can be imported into the app.

### Usage

```bash
# Validate files in the default test_import_files directory
./scripts/validate_imports.sh

# Validate files in a specific directory
./scripts/validate_imports.sh my_json_files
```

### What it does

The script will:
1. Scan the specified directory for JSON files
2. Validate each file's structure and content
3. Check for common issues like missing names, invalid statuses, etc.
4. Provide a detailed summary of validation results
5. Show specific error messages for any problems found

### Example Output

```
🔍 Import Validation Script
==========================

📁 Testing directory: my_json_files
📄 Found 3 JSON files

Files to validate:
2023-04.json
2023-H1.json
sample.json

🧪 Running validation tests...

📄 Testing: 2023-04.json
  ✅ Valid: 5 events, 12 unique dancers

📄 Testing: 2023-H1.json
  ❌ Errors:
    - Event 1: Event name is required and cannot be null or empty
    - Event 3: Invalid status: 'unknown'. Must be one of: present, served, left

📊 Validation Summary:
  Files tested: 3
  Valid files: 2
  Total events: 8
  Total attendances: 25
  Total unique dancers: 18
  ✅ Success rate: 66.7%
```

## fix_event_names.py

This script automatically fixes JSON event files by adding default names to events that are missing them. This allows importing historical event data even when event names are missing.

### Usage

```bash
# Fix a file and create a new output file
python3 scripts/fix_event_names.py input_file.json output_file.json

# Fix a file in place (overwrites the original)
python3 scripts/fix_event_names.py input_file.json
```

### What it does

The script will:
1. Read your JSON event file
2. Check each event for missing, null, or empty `name` fields
3. Generate default names like "Event on January 15, 2024" based on the event date
4. Save the fixed file

### Example

**Before:**
```json
{
  "events": [
    {
      "name": null,
      "date": "2024-01-15",
      "attendances": [...]
    },
    {
      "date": "2024-01-20",
      "attendances": [...]
    }
  ]
}
```

**After:**
```json
{
  "events": [
    {
      "name": "Event on January 15, 2024",
      "date": "2024-01-15",
      "attendances": [...]
    },
    {
      "name": "Event on January 20, 2024",
      "date": "2024-01-20",
      "attendances": [...]
    }
  ]
}
```

### Requirements

- Python 3.6 or higher
- No additional dependencies required

### Notes

- The script preserves all other data in your JSON files
- Events that already have valid names are left unchanged
- Default names are generated in a readable format (e.g., "Event on January 15, 2024")
- The script handles various date formats automatically 