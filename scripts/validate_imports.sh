#!/bin/bash

# Script to validate JSON import files
# Usage: ./scripts/validate_imports.sh [directory]

set -e

# Default directory
TEST_DIR=${1:-"test_import_files"}

echo "🔍 Import Validation Script"
echo "=========================="
echo ""

# Check if test directory exists
if [ ! -d "$TEST_DIR" ]; then
    echo "⚠️  Directory '$TEST_DIR' not found."
    echo ""
    echo "Usage:"
    echo "  ./scripts/validate_imports.sh [directory]"
    echo ""
    echo "Examples:"
    echo "  ./scripts/validate_imports.sh                    # Uses 'test_import_files'"
    echo "  ./scripts/validate_imports.sh my_json_files      # Uses 'my_json_files'"
    echo ""
    echo "To test your files:"
    echo "  1. Create a directory with your JSON files"
    echo "  2. Run: ./scripts/validate_imports.sh your_directory"
    echo ""
    exit 1
fi

# Count JSON files
JSON_COUNT=$(find "$TEST_DIR" -name "*.json" | wc -l)

if [ "$JSON_COUNT" -eq 0 ]; then
    echo "⚠️  No JSON files found in '$TEST_DIR'"
    exit 1
fi

echo "📁 Testing directory: $TEST_DIR"
echo "📄 Found $JSON_COUNT JSON files"
echo ""

# List all JSON files
echo "Files to validate:"
find "$TEST_DIR" -name "*.json" -exec basename {} \; | sort
echo ""

# Run the Dart test
echo "🧪 Running validation tests..."
echo ""

# Set the test directory as an environment variable
export TEST_IMPORT_DIRECTORY="$TEST_DIR"

# Run the specific test
flutter test test/import_validation_test.dart --reporter=expanded

echo ""
echo "✅ Validation complete!" 