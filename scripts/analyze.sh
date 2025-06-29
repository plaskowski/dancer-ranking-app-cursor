#!/bin/bash

# Dancer Ranking App - Code Quality Script
# This script runs analysis and formatting for the project

echo "🔍 Running Flutter analyze..."
flutter analyze --no-fatal-infos --no-fatal-warnings

echo ""
echo "🎨 Formatting Dart files..."
dart format lib/ test/

echo ""
echo "✅ Code quality check complete!"
echo "📊 Analysis results shown above"
echo "🎯 Use this script regularly to maintain code quality" 