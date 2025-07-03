# Event Import Scripts

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